require File.dirname(__FILE__) + '/../spec_helper'

describe Transcoder do
  describe "scheduling a job" do
    before(:each) do
      @preset = FactoryGirl.create(:preset)
      @job    = FactoryGirl.create(:job, :preset_id => @preset.id)
      @host   = FactoryGirl.create(:host)

      Transcoder.stub(:post)
    end

    def do_schedule
      Transcoder.schedule(:job => @job, :host => @host)
    end

    describe "success" do
      before(:each) do
        Transcoder.stub(:post).and_return({'foo' => 'bar'})
      end
      
      it "should return the correct attributes" do
        do_schedule.should == { 'host_id' => @host.id, 'foo' => 'bar' }
      end
    end

    describe "failed" do
      before(:each) do
        Transcoder.stub(:post).and_return false
      end

      it "should remain in scheduled state" do
        do_schedule
        @job.state.should == Job::Scheduled
      end
    end
    
    it "should convert a job to transcoder params correctly" do
      # with thumbnail options presetn
      Transcoder.job_to_json(@job).should == {
        'source_file' => 'source',
        'destination_file' => 'dest',
        'encoder_options' => 'params',
        'thumbnail_options' => {seconds: 1},
        'callback_urls' => ["callback_url"]
      }.to_json
      
      # without thumbnail options
      @job.preset.thumbnail_options = nil
      Transcoder.job_to_json(@job).should == {
        'source_file' => 'source',
        'destination_file' => 'dest',
        'encoder_options' => 'params',
        'thumbnail_options' => nil,
        'callback_urls' => ["callback_url"]
      }.to_json
    end
  end

  describe "getting a host's status" do
    before(:each) do
      @host = FactoryGirl.create(:host)
      Transcoder.stub(:call_transcoder).and_return true
    end
    
    def do_get
      Transcoder.host_status(@host)
    end
    
    it "should get the status" do
      Transcoder.should_receive(:call_transcoder).with(:get, "url/jobs")
      do_get.should == true
    end
  end
  
  describe "getting a job's status" do
    before(:each) do
      @host = FactoryGirl.create(:host)
      @job  = FactoryGirl.create(:job, :host_id => @host.id)
      Transcoder.stub(:call_transcoder).and_return true
    end
    
    def do_get
      Transcoder.job_status(@job)
    end
    
    it "should get the status" do
      Transcoder.should_receive(:call_transcoder).with(:get, "url/jobs/1")
      do_get.should == true
    end
  end

  describe "POSTing to the transcoders" do
    before(:each) do
      RestClient.stub(:post).and_return '{"foo":"bar"}'
    end
    
    def do_post
      Transcoder.post('url', {'foo' => 'bar'})
    end
    
    it "should make the correct call" do
      RestClient.should_receive(:post).with('url', {'foo' => 'bar'}, {:content_type => :json, :accept => :json, :timeout => 2})
      do_post.should == {'foo' => 'bar'}
    end
    
    [RestClient::Exception, Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, JSON::ParserError].each do |ex|
      it "should recover from #{ex}" do
        RestClient.stub(:post).and_raise ex
        do_post.should == false
      end
    end
  end
  
  describe "GETting from the transcoders" do
    before(:each) do
      RestClient.stub(:get).and_return '{"foo":"bar"}'
    end
    
    def do_get
      Transcoder.get('url', {'foo' => 'bar'})
    end
    
    it "should make the correct call" do
      RestClient.should_receive(:get).with('url', {'foo' => 'bar'}, {:content_type => :json, :accept => :json, :timeout => 2})
      do_get
    end

    [RestClient::Exception, Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, Errno::EHOSTUNREACH, JSON::ParserError].each do |ex|
      it "should recover from #{ex}" do
        RestClient.stub(:get).and_raise ex
        do_get.should == false
      end
    end
  end
end

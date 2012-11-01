require File.dirname(__FILE__) + '/../spec_helper'

describe Transcoder do
  describe "scheduling a job" do
    before(:each) do
      @preset = FactoryGirl.create(:preset)
      @job    = FactoryGirl.create(:job, :preset_id => @preset.id, :additional_params => 'additional')
      @host   = FactoryGirl.create(:host)

      Transcoder.stub!(:post)
    end

    def do_schedule
      Transcoder.schedule(:job => @job, :host => @host)
    end

    it "should post the job correctly to the host" do
      Transcoder.should_receive(:job_to_json).with(@job).and_return 'payload'
      Transcoder.should_receive(:post).with("url/jobs", {payload: 'payload'})
      do_schedule
    end

    it "should convert a job to transcoder params correctly" do
      Transcoder.job_to_json(@job).should == {
        'source_file' => 'source',
        'destination_file' => 'dest',
        'encoder_options' => 'params additional',
        'callback_urls' => ["callback_url"],
      }.to_json
    end

    describe "success" do
      before(:each) do
        Transcoder.stub!(:post).and_return({'foo' => 'bar'})
      end
      
      it "should return the correct attributes" do
        do_schedule.should == { 'host_id' => @host.id, 'foo' => 'bar' }
      end
    end

    describe "failed" do
      before(:each) do
        Transcoder.stub!(:post).and_return false
      end

      it "should remain in scheduled state" do
        do_schedule
        @job.state.should == Job::Scheduled
      end
    end
  end

  describe "getting a host's status" do
    before(:each) do
      @host = FactoryGirl.create(:host)
      Transcoder.stub!(:call_transcoder).and_return true
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
      Transcoder.stub!(:call_transcoder).and_return true
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
      RestClient::Request.stub!(:execute).and_return '{"foo":"bar"}'
    end
    
    def do_post
      Transcoder.post('url', {'foo' => 'bar'})
    end
    
    it "should make the correct call" do
      RestClient::Request.should_receive(:execute).with(:url => 'url', 'foo' => 'bar', :method => :post, :content_type => :json, :accept => :json, :timeout => 1)
      do_post.should == {'foo' => 'bar'}
    end
    
    [RestClient::Exception, Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, JSON::ParserError].each do |ex|
      it "should recover from #{ex}" do
        RestClient::Request.stub!(:execute).and_raise ex
        do_post.should == false
      end
    end
  end
  
  describe "GETting from the transcoders" do
    before(:each) do
      RestClient::Request.stub!(:execute).and_return '{"foo":"bar"}'
    end
    
    def do_get
      Transcoder.get('url', {'foo' => 'bar'})
    end
    
    it "should make the correct call" do
      RestClient::Request.should_receive(:execute).with(:url => 'url', 'foo' => 'bar', :method => :get, :content_type => :json, :accept => :json, :timeout => 1)
      do_get.should == { 'foo' => 'bar' }
    end

    [RestClient::Exception, Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, Errno::EHOSTUNREACH, JSON::ParserError].each do |ex|
      it "should recover from #{ex}" do
        RestClient::Request.stub!(:execute).and_raise ex
        do_get.should == false
      end
    end
  end
end

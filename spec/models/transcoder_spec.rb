require File.dirname(__FILE__) + '/../spec_helper'

describe Transcoder do
  describe "scheduling a job" do
    before(:each) do
      @preset = Preset.create!(:name => 'h264', :parameters => 'params')
      @job    = Job.create!(:source_file => 'source', :destination_file => 'dest', :preset => @preset, :callback_url => 'callback_url')
      @host   = Host.create!(:name => 'name', :url => 'url')

      Transcoder.stub!(:post)
    end

    def do_schedule
      Transcoder.schedule(:job => @job, :host => @host)
    end

    describe "success" do
      before(:each) do
        Transcoder.stub!(:post).and_return({'foo' => 'bar'})
      end
      
      it "the job should enter transcoding" do
        @job.should_receive(:enter).with(Job::Transcoding, {'foo' => 'bar', 'host_id' => @host.id})
        do_schedule
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
    
    it "should convert a job to transcoder params correctly" do
      Transcoder.job_to_json(@job).should == {
        'source_file' => 'source',
        'destination_file' => 'dest',
        'encoder_options' => 'params',
        'callback_urls' => ["callback_url/#{@job.to_param}"]
      }.to_json
    end
  end

  describe "getting a host's status" do
    before(:each) do
      @host = Host.create!(:name => 'name', :url => 'url')
      Transcoder.stub!(:call_transcoder).and_return true
    end
    
    def do_get
      Transcoder.status(@host)
    end
    
    it "should get the status" do
      Transcoder.should_receive(:call_transcoder).with(:get, "url/jobs")
      do_get.should == true
    end
  end

  describe "POSTing to the transcoders" do
    before(:each) do
      RestClient.stub!(:post).and_return '{"foo":"bar"}'
    end
    
    def do_post
      Transcoder.post('url', {'foo' => 'bar'})
    end
    
    it "should make the correct call" do
      RestClient.should_receive(:post).with('url', {'foo' => 'bar'}, {:content_type => :json, :accept => :json})
      do_post.should == {'foo' => 'bar'}
    end
    
    [RestClient::ResourceNotFound, Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH].each do |ex|
      it "should recover from #{ex}" do
        RestClient.stub!(:post).and_raise ex
        do_post.should == false
      end
    end
  end
  
  describe "GETting from the transcoders" do
    before(:each) do
      RestClient.stub!(:get).and_return '{"foo":"bar"}'
    end
    
    def do_get
      Transcoder.get('url', {'foo' => 'bar'})
    end
    
    it "should make the correct call" do
      RestClient.should_receive(:get).with('url', {'foo' => 'bar'}, {:content_type => :json, :accept => :json})
      do_get
    end

    [RestClient::ResourceNotFound, Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH].each do |ex|
      it "should recover from #{ex}" do
        RestClient.stub!(:get).and_raise ex
        do_get.should == false
      end
    end
  end
end

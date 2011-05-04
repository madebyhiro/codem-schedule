require File.dirname(__FILE__) + '/../spec_helper'

describe Transcoder do
  describe "scheduling a job" do
    before(:each) do
      @preset = Preset.create!(:name => 'h264', :parameters => 'params')
      @job    = Job.create!(:source_file => 'source', :destination_file => 'dest', :preset => @preset)
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
        'callback_urls' => ["http://127.0.0.1:3000/api/jobs/#{@job.id}"]
      }.to_json
    end
  end

  describe "getting a host's status" do
    before(:each) do
      @host = Host.create!(:name => 'name', :url => 'url')
      Transcoder.stub!(:get).and_return true
    end
    
    def do_get
      Transcoder.status(@host)
    end
    
    it "should get the status" do
      Transcoder.should_receive(:get).with("url/jobs")
      do_get.should == true
    end
  end

  describe "POSTing to the transcoders" do
    before(:each) do
      RestClient.stub!(:post).and_return '{"foo":"bar"}'
    end
    
    def do_post
      Transcoder.post('url', 'attrs')
    end
    
    it "should make the correct call" do
      RestClient.should_receive(:post).with('url', 'attrs', :content_type => :json, :accept => :json)
      do_post.should == {'foo' => 'bar'}
    end
    
    it "should recover from a connection refused error" do
      RestClient.stub!(:post).and_raise Errno::ECONNREFUSED
      do_post.should == false
    end
  end
  
  describe "GETting from the transcoders" do
    before(:each) do
      RestClient.stub!(:get).and_return '{"foo":"bar"}'
    end
    
    def do_get
      Transcoder.get('url', 'attrs')
    end
    
    it "should make the correct call" do
      RestClient.should_receive(:get).with('url', 'attrs', :content_type => :json, :accept => :json)
      do_get
    end
    
    it "should recover from a connection refused error" do
      RestClient.stub!(:get).and_raise Errno::ECONNREFUSED
      do_get.should == false
    end
  end
end

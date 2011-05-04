require 'spec_helper'

describe Api::JobsController do
  before(:each) do
    @preset = Preset.create!(:name => 'h264', :parameters => 'params')
  end

  def create_job
    @job = Job.create!(:source_file => 'input', :destination_file => 'output', :preset => @preset)
  end
  
  describe "POST 'create'" do
    def do_post
      post "create", :input => 'input', :output => 'output', :preset => 'h264'
    end
    
    it "creates jobs" do
      do_post

      job = Job.last
      job.source_file.should == 'input'
      job.destination_file.should == 'output'
      job.preset.name.should == 'h264'
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      create_job
    end
    
    def do_get(format)
      get 'show', :id => @job.id, :format => format
    end
    
    it "shows a job as JSON" do
      do_get(:json)
      response.body.should == {:job => @job.attributes}.to_json
    end
    
    it "shows a job as XML" do
      do_get(:xml)
      response.body.should == @job.attributes.to_xml(:root => 'job')
    end
  end
  
  describe "GET 'index'" do
    before(:each) do
      create_job
    end
    
    def do_get(format)
      get 'index', :format => format
    end
    
    it "shows jobs as JSON" do
      do_get(:json)
      response.body.should == Job.all.to_json
    end
    
    it "shows jobs as XML" do
      do_get(:xml)
      response.body.should == Job.all.to_xml
    end
  end
  
  describe "GET 'scheduled'" do
    before(:each) do
      create_job
      @job.update_attributes(:state => Job::Scheduled)
    end
    
    def do_get(format)
      get 'scheduled', :format => format
    end
    
    it "shows scheduled jobs as JSON" do
      do_get(:json)
      response.body.should == [@job].to_json
    end
    
    it "shows scheduled jobs as XML" do
      do_get(:xml)
      response.body.should == [@job].to_xml
    end
  end

  describe "GET 'transcoding'" do
    before(:each) do
      create_job
      @job.update_attributes(:state => Job::Transcoding)
    end
    
    def do_get(format)
      get 'transcoding', :format => format
    end
    
    it "shows transcoding jobs as JSON" do
      do_get(:json)
      response.body.should == [@job].to_json
    end
    
    it "shows transcoding jobs as XML" do
      do_get(:xml)
      response.body.should == [@job].to_xml
    end
  end
  
  describe "GET 'on_hold'" do
    before(:each) do
      create_job
      @job.update_attributes(:state => Job::OnHold)
    end
    
    def do_get(format)
      get 'on_hold', :format => format
    end
    
    it "shows on hold jobs as JSON" do
      do_get(:json)
      response.body.should == [@job].to_json
    end
    
    it "shows on hold jobs as XML" do
      do_get(:xml)
      response.body.should == [@job].to_xml
    end
  end
  
  describe "GET 'completed'" do
    before(:each) do
      create_job
      @job.update_attributes(:state => Job::Completed)
    end
    
    def do_get(format)
      get 'completed', :format => format
    end
    
    it "shows completed jobs as JSON" do
      do_get(:json)
      response.body.should == [@job].to_json
    end
    
    it "shows completed jobs as XML" do
      do_get(:xml)
      response.body.should == [@job].to_xml
    end
  end

  describe "GET 'failed'" do
    before(:each) do
      create_job
      @job.update_attributes(:state => Job::Failed)
    end
    
    def do_get(format)
      get 'failed', :format => format
    end
    
    it "shows failed jobs as JSON" do
      do_get(:json)
      response.body.should == [@job].to_json
    end
    
    it "shows failed jobs as XML" do
      do_get(:xml)
      response.body.should == [@job].to_xml
    end
  end
end

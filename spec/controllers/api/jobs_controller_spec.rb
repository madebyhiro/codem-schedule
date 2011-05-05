require 'spec_helper'

describe Api::JobsController do
  before(:each) do
    @preset = Factory(:preset)
  end

  def create_job
    @job = Factory(:job)
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
      @job.stub!(:update_status)
      Job.stub!(:find).and_return @job
    end
    
    def do_get(format=:json)
      get 'show', :id => @job.id, :format => format
    end
    
    it "should update the job's status" do
      @job.should_receive(:update_status)
      do_get
    end
    
    it "shows a job as JSON" do
      do_get(:json)
      response.body.should == {:job => @job.attributes}.to_json
    end

    # bug in to_xml
    # it "shows a job as XML" do
    #   do_get(:xml)
    #   response.body.should == @job.attributes.to_xml(:root => 'job')
    # end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      create_job
      @job.stub!(:enter)
      Job.stub!(:find).and_return @job
    end
    
    def do_put
      put 'update', :id => @job.id, :status => 'status'
    end
    
    it "should find the job" do
      Job.should_receive(:find).with(@job.id)
      do_put
    end
    
    it "should enter the correct state" do
      @job.should_receive(:enter).with('status', {"status"=>"status", "id"=>@job.id, "controller"=>"api/jobs", "action"=>"update"})
      do_put
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
      Job.stub_chain(:transcoding, :page, :per).and_return [@job]
      @job.stub!(:update_status)
    end
    
    def do_get(format)
      get 'transcoding', :format => format
    end
    
    it "should update the job's status" do
      @job.should_receive(:update_status)
      do_get(:json)
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
  
  describe "GET 'success'" do
    before(:each) do
      create_job
      @job.update_attributes(:state => Job::Success)
    end
    
    def do_get(format)
      get 'success', :format => format
    end
    
    it "shows success jobs as JSON" do
      do_get(:json)
      response.body.should == [@job].to_json
    end
    
    it "shows success jobs as XML" do
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

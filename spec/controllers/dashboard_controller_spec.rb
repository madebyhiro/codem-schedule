require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do
  describe "GET 'show'" do
    before(:each) do
      @jobs = mock("Array of jobs", :update_status => true)
      @jobs.stub!(:map).and_return @jobs
      
      @job = double(Job)
      @job.stub!(:update_status).and_return @job
      
      Job.stub_chain(:recents, :limit).and_return @jobs
      @jobs.stub!(:scheduled).and_return 'scheduled'
      @jobs.stub!(:processing).and_return [@job]
      @jobs.stub!(:failed).and_return 'failed'
      
      History.stub!(:new).and_return 'history'
    end
    
    def do_get
      get 'show', :period => 'period'
    end
    
    it "should assign the recently scheduled jobs" do
      do_get
      assigns[:scheduled_jobs].should == 'scheduled'
    end
    
    it "should assign the recently processing jobs" do
      do_get
      assigns[:processing_jobs].should == [@job]
    end
    
    it "should update the status of the processing jobs" do
      @job.should_receive(:update_status)
      do_get
    end
    
    it "should assign the recently failed jobs" do
      do_get
      assigns[:failed_jobs].should == 'failed'
    end
    
    it "should generate a new history" do
      History.should_receive(:new).with('period')
      do_get
    end
    
    it "should assign the history for the view" do
      do_get
      assigns[:history].should == 'history'
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do
  describe "GET 'show'" do
    before(:each) do
      @jobs = mock("Array of jobs", :update_status => true)
      @jobs.stub!(:map).and_return @jobs
      
      Job.stub_chain(:recents, :limit).and_return @jobs
      @jobs.stub!(:scheduled).and_return 'scheduled'
      @jobs.stub!(:processing).and_return 'processing'
      @jobs.stub!(:failed).and_return 'failed'
    end
    
    def do_get
      get 'show'
    end
    
    it "should assign the recently scheduled jobs" do
      do_get
      assigns[:scheduled_jobs].should == 'scheduled'
    end
    
    it "should assign the recently processing jobs" do
      do_get
      assigns[:processing_jobs].should == 'processing'
    end
    
    it "should assign the recently failed jobs" do
      do_get
      assigns[:failed_jobs].should == 'failed'
    end
  end
end

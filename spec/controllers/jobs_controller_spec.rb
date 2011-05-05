require 'spec_helper'

describe JobsController do
  describe "GET 'index'" do
    before(:each) do
      Job.stub!(:recents).and_return 'recent'
    end
    
    def do_get
      get 'index'
    end
    
    it "should find the recent jobs" do
      Job.should_receive(:recents)
      do_get
    end
    
    it "should assign the recent jobs for the view" do
      do_get
      assigns[:jobs].should == 'recent'
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @job = double(Job, :update_status => true)
      Job.stub!(:find).and_return @job
    end
    
    def do_get
      get 'show', :id => 1
    end
    
    it "should find the jobs" do
      Job.should_receive(:find).with(1)
      do_get
    end
    
    it "should assign the job for the view" do
      do_get
      assigns[:job].should == @job
    end
    
    it "should update the status" do
      @job.should_receive(:update_status)
      do_get
    end
  end
end

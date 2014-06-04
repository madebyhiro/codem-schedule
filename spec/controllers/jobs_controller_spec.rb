require 'spec_helper'

describe JobsController do
  describe "GET 'index'" do
    before(:each) do
      @job = double(Job)
      Job.stub(:recents).and_return [@job]
      History.stub(:new).and_return 'history'
    end
    
    def do_get
      get 'index', :period => 'period'
    end
    
    it "should generate the correct history" do
      History.should_receive(:new).with('period')
      do_get
    end
    
    it "should assign the history for the view" do
      do_get
      assigns[:history].should == 'history'
    end
    
    it "should find the recent jobs" do
      Job.should_receive(:recents)
      do_get
    end
    
    it "should assign the recent jobs for the view" do
      do_get
      assigns[:jobs].should == [@job]
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @job = double(Job)
      Job.stub(:find).and_return @job
    end
    
    def do_get
      get 'show', :id => 1
    end
    
    it "should find the jobs" do
      Job.should_receive(:find).and_return @job
      do_get
    end
    
    it "should assign the job for the view" do
      do_get
      assigns[:job].should == @job
    end
  end

  describe "GET 'new'" do
    before(:each) do
      @job = double(Job)
      Job.stub(:new).and_return @job
    end

    def do_get
      get 'new'
    end

    it "should generate a new job" do
      Job.should_receive(:new)
      do_get
    end

    it "should assign the job for the view" do
      do_get
      assigns[:job].should == @job
    end
  end
end

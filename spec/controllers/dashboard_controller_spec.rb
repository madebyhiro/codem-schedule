require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do
  describe "GET 'index'" do
    before(:each) do
      Job.stub!(:recent).and_return 'recent'
      @history = double(History)
      History.stub!(:new).and_return @history
    end
    
    def do_get
      get 'index', :period => 'period'
    end
    
    it "should get the recent jobs" do
      Job.should_receive(:recent)
      do_get
    end
    
    it "should assign the recent jobs for the view" do
      do_get
      assigns[:jobs].should == 'recent'
    end
    
    it "should generate a new history model" do
      History.should_receive(:new).with('period')
      do_get
    end
    
    it "should assign the history model for the view" do
      do_get
      assigns[:history].should == @history
    end
  end
end

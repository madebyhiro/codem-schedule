require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::SchedulerController do
  describe "GET 'schedule'" do
    before(:each) do
      Runner.stub!(:schedule!)
    end
    
    def do_get
      get 'schedule'
    end
    
    it "should let the runner schedule" do
      Runner.should_receive(:schedule!)
      do_get
    end
    
    it "should render nothing" do
      do_get
      response.body.should == ' '
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe HostsController do
  describe "GET 'index'" do
    before(:each) do
      Host.stub!(:all).and_return 'hosts'
    end
    
    def do_get
      get 'index'
    end
    
    it "should get the hosts" do
      Host.should_receive(:all)
      do_get
    end
    
    it "should assign the hosts for the view" do
      do_get
      assigns[:hosts].should == 'hosts'
    end
  end
  
  describe "GET 'new'" do
    it "should render the view" do
      get 'new'
      response.should render_template('new')
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe HostsController do
  describe "GET 'index'" do
    before(:each) do
      @host = double(Host, :update_status => true)
      Host.stub!(:all).and_return [@host]
    end
    
    def do_get
      get 'index'
    end
    
    it "should get the hosts" do
      Host.should_receive(:all)
      do_get
    end
    
    it "should update their status" do
      @host.should_receive(:update_status)
      do_get
    end
    
    it "should assign the hosts for the view" do
      do_get
      assigns[:hosts].should == [@host]
    end
  end
  
  describe "GET 'new'" do
    before(:each) do
      @host = double(Host)
      Host.stub!(:new).and_return @host
    end

    def do_get
      get 'new'
    end
    
    it "should generate a new host" do
      Host.should_receive(:new)
      do_get
    end

    it "should assign the host for the view" do
      do_get
      assigns[:host].should == @host
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @host = double(Host)
      Host.stub!(:find).and_return @host
    end
    
    def do_get
      get 'edit', :id => 1
    end
    
    it "should find the host" do
      Host.should_receive(:find).with(1)
      do_get
    end
    
    it "should assign the host for the view" do
      do_get
      assigns[:host].should == @host
    end
  end
end

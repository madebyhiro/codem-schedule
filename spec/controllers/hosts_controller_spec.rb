require File.dirname(__FILE__) + '/../spec_helper'

describe HostsController, :type => :controller do
  describe "GET 'index'" do
    before(:each) do
      @host = double(Host, :update_status => true)
      allow(Host).to receive(:all).and_return [@host]
    end
    
    def do_get
      get 'index'
    end
    
    it "should get the hosts" do
      expect(Host).to receive(:all)
      do_get
    end
    
    it "should update their status" do
      expect(@host).to receive(:update_status)
      do_get
    end
    
    it "should assign the hosts for the view" do
      do_get
      expect(assigns[:hosts]).to eq([@host])
    end
  end
  
  describe "GET 'new'" do
    before(:each) do
      @host = double(Host)
      allow(Host).to receive(:new).and_return @host
    end

    def do_get
      get 'new'
    end
    
    it "should generate a new host" do
      expect(Host).to receive(:new)
      do_get
    end

    it "should assign the host for the view" do
      do_get
      expect(assigns[:host]).to eq(@host)
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @host = double(Host)
      allow(Host).to receive(:find).and_return @host
    end
    
    def do_get
      get 'edit', :id => 1
    end
    
    it "should find the host" do
      expect(Host).to receive(:find).with('1')
      do_get
    end
    
    it "should assign the host for the view" do
      do_get
      expect(assigns[:host]).to eq(@host)
    end
  end
end

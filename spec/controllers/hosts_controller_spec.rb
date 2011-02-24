require 'spec_helper'

describe HostsController do
  describe "GET 'index'" do
    before(:each) do
      Host.stub!(:all).and_return 'hosts'
    end
    
    def do_get
      get 'index'
    end
    
    it "should find the hosts" do
      Host.should_receive(:all)
      do_get
    end
    
    it "should assign the hosts for the view" do
      do_get
      assigns[:hosts].should == 'hosts'
    end
  end
  
  describe "GET 'new'" do
    before(:each) do
      @host = mock_model(Host)
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
  
  describe "POST 'create'" do
    before(:each) do
      @host = mock_model(Host, :save => true)
      Host.stub!(:new).and_return @host
    end
    
    def do_post
      post "create", :host => {}
    end
    
    it "should generate a new host" do
      Host.should_receive(:new).with({})
      do_post
    end
    
    it "should assign the host for the vide" do
      do_post
      assigns[:host].should == @host
    end
    
    it "should save the host" do
      @host.should_receive(:save)
      do_post
    end
    
    describe "with successfull save" do
      it "should set the flash" do
        do_post
        flash[:notice].should == 'Host has been added'
      end
      
      it "should redirect to the index" do
        do_post
        response.should redirect_to(hosts_path)
      end
    end
    
    describe "with failed save" do
      before(:each) do
        @host.stub!(:save).and_return false
      end
      
      it "should set the flash" do
        do_post
        flash[:error].should == "Host could not be saved"
      end
      
      it "should re-render new" do
        do_post
        response.should render_template('new')
      end
    end
  end
end

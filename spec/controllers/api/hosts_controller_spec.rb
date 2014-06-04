require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::HostsController do
  before(:each) do
    Time.stub(:now).and_return Time.utc(2011,1,2,3,4,5)
    Transcoder.stub(:host_status).and_return {}
  end
  
  def create_host
    @host = FactoryGirl.create(:host)
  end
  
  describe "GET 'index'" do
    before(:each) do
      create_host
    end
    
    def do_get(format)
      get 'index', :format => format
    end
    
    it "shows hosts as JSON" do
      do_get(:json)
      response.body.should == Host.all.to_json
    end
    
    it "shows jobs as XML" do
      do_get(:xml)
      response.body.should == Host.all.to_xml
    end
  end
  
  describe "POST 'create'" do
    def do_post(format=:json)
      post 'create', :name => 'name', :url => 'url', :format => format
    end
    
    it "creates hosts" do
      do_post
      host = Host.last
      host.name.should == 'name'
      host.url.should == 'url'
    end
    
    it "should redirect to /hosts if :html" do
      do_post(:html)
      response.should redirect_to(hosts_path)
    end
    
    it "should render /hosts/new if invalid and :html" do
      post 'create', :name => 'name', :format => :html
      response.should render_template(:new)
    end
  end
  
  describe "GET 'show'" do
    subject { FactoryGirl.create(:host) }
    
    def do_get(format)
      get 'show', :id => subject.id, :format => format
    end
    
    it "shows a job as json" do
      do_get(:json)
      expected = JSON.load(subject.to_json)
      actual   = JSON.load(response.body)
      expected.slice(:created_at, :updated_at).should == actual.slice(:created_at, :updated_at)
    end
    
    it "shows a job as xml" do
      do_get(:xml)
      response.body.should == subject.to_xml
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      create_host
      Host.last.update_attribute :available, true
    end
    
    def do_put(format)
      put 'update', :id => @host.id, :name => 'name', :url => 'url', :format => format
      @host.reload
    end

    it "should update a host as JSON" do
      do_put(:json)
      @host.name.should == 'name'
      @host.url.should == 'url'
    end

    it "should have updated the status" do
      @host.should_not be_available
    end
    
    it "should update a host as XML" do
      do_put(:xml)
      @host.name.should == 'name'
      @host.url.should == 'url'
    end
    
    it "should redirect to the hosts path as HTML" do
      do_put(:html)
      response.should redirect_to(hosts_path)
    end
    
    it "should re-render /hosts/edit if the update fails as HTML" do
      put 'update', :id => @host.id, :name => nil, :format => :html
      response.should render_template(:edit)
    end
    
    it "should also work with a Rails-style form" do
      put 'update', :host => {:name => 'rails-name', :url => 'rails-url'}, :id => @host.id
      @host.reload
      @host.name.should == 'rails-name'
      @host.url.should == 'rails-url'
    end

  end
  
  describe "DELETE 'destroy'" do
    before(:each) do
      @host = create_host
    end
    
    def do_delete
      delete :destroy, :id => @host.id
    end
    
    it "should delete the host" do
      do_delete
      Host.count.should == 0
    end
  end

end

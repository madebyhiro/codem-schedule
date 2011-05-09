require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::HostsController do
  def create_host
    @host = Factory(:host)
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
      response.should render_template('/hosts/new')
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      create_host
    end
    
    def do_get(format)
      get 'show', :id => @host.id, :format => format
    end
    
    it "shows a job as json" do
      do_get(:json)
      response.body.should == @host.to_json
    end
    
    it "shows a job as xml" do
      do_get(:xml)
      response.body.should == @host.to_xml
    end
  end
end

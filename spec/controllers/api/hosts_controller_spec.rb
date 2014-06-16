require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::HostsController, :type => :controller do
  before(:each) do
    allow(Time).to receive(:now).and_return Time.utc(2011,1,2,3,4,5)
    allow(Transcoder).to receive(:host_status) {}
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
      expect(response.body).to eq(Host.all.to_json)
    end
    
    it "shows jobs as XML" do
      do_get(:xml)
      expect(response.body).to eq(Host.all.to_xml)
    end
  end
  
  describe "POST 'create'" do
    def do_post(format=:json)
      post 'create', :name => 'name', :url => 'url', :format => format
    end
    
    it "creates hosts" do
      do_post
      host = Host.last
      expect(host.name).to eq('name')
      expect(host.url).to eq('url')
    end
    
    it "should redirect to /hosts if :html" do
      do_post(:html)
      expect(response).to redirect_to(hosts_path)
    end
    
    it "should render /hosts/new if invalid and :html" do
      post 'create', :name => 'name', :format => :html
      expect(response).to render_template(:new)
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
      expect(expected.slice(:created_at, :updated_at)).to eq(actual.slice(:created_at, :updated_at))
    end
    
    it "shows a job as xml" do
      do_get(:xml)
      expect(response.body).to eq(subject.to_xml)
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
      expect(@host.name).to eq('name')
      expect(@host.url).to eq('url')
    end

    it "should have updated the status" do
      expect(@host).not_to be_available
    end
    
    it "should update a host as XML" do
      do_put(:xml)
      expect(@host.name).to eq('name')
      expect(@host.url).to eq('url')
    end
    
    it "should redirect to the hosts path as HTML" do
      do_put(:html)
      expect(response).to redirect_to(hosts_path)
    end
    
    it "should re-render /hosts/edit if the update fails as HTML" do
      put 'update', :id => @host.id, :name => nil, :format => :html
      expect(response).to render_template(:edit)
    end
    
    it "should also work with a Rails-style form" do
      put 'update', :host => {:name => 'rails-name', :url => 'rails-url'}, :id => @host.id
      @host.reload
      expect(@host.name).to eq('rails-name')
      expect(@host.url).to eq('rails-url')
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
      expect(Host.count).to eq(0)
    end
  end

end

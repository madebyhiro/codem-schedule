require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::PresetsController do
  def create_preset
    @preset = FactoryGirl.create(:preset)
  end
  
  describe "POST 'create'" do
    def do_post(format=:json)
      post 'create', :name => 'name', :parameters => 'params', :format => format
    end
    
    it "creates presets" do
      do_post
      preset = Preset.last
      preset.name.should == 'name'
      preset.parameters.should == 'params'
    end
    
    it "should redirect to /presets if :html" do
      do_post(:html)
      response.should redirect_to(presets_path)
    end
    
    it "should render /presets/new if invalid and :html" do
      post 'create', :name => 'name', :format => :html
      response.should render_template(:new)
    end
  end
  
  describe "GET 'show'" do
    subject { FactoryGirl.create(:preset) }
    
    def do_get(format)
      get 'show', :id => subject.id, :format => format
    end
    
    it "shows a preset as JSON" do
      do_get(:json)
      expected = JSON.load(subject.to_json)
      actual   = JSON.load(response.body)
      expected.slice(:created_at, :updated_at).should == actual.slice(:created_at, :updated_at)
    end

    it "shows a preset as XML" do
      do_get(:xml)
      response.body.should == subject.to_xml
    end
  end
  
  describe "GET 'index'" do
    before(:each) do
      create_preset
    end
    
    def do_get(format)
      get 'index', :format => format
    end
    
    it "shows presets as JSON" do
      do_get(:json)
      response.body.should == Preset.all.to_json
    end

    it "shows presets as XML" do
      do_get(:xml)
      response.body.should == Preset.all.to_xml
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      create_preset
    end
    
    def do_put(format)
      put 'update', :id => @preset.id, :name => 'name', :parameters => 'params', :format => format
      @preset.reload
    end
    
    it "should update a preset as JSON" do
      do_put(:json)
      @preset.name.should == 'name'
      @preset.parameters.should == 'params'
    end

    it "should update a preset as XML" do
      do_put(:xml)
      @preset.name.should == 'name'
      @preset.parameters.should == 'params'
    end
    
    it "should redirect to the presets path as HTML" do
      do_put(:html)
      response.should redirect_to(presets_path)
    end
    
    it "should re-render /presets/edit if the update fails as HTML" do
      put 'update', :id => @preset.id, :name => nil, :format => :html
      response.should render_template(:edit)
    end
    
    it "should work with a Rails-style hash" do
      put 'update', :id => @preset.id, :preset => {:name => 'rails-name', :parameters => 'rails-params'}
      @preset.reload
      @preset.name.should == 'rails-name'
      @preset.parameters.should == 'rails-params'
    end
  end
  
  describe "DELETE 'destroy'" do
    before(:each) do
      @preset = create_preset
    end
    
    def do_delete
      delete :destroy, :id => @preset.id
    end
    
    it "should delete the preset" do
      do_delete
      Preset.count.should == 0
    end
  end
end

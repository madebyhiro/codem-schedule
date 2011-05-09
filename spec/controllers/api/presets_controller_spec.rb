require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::PresetsController do
  def create_preset
    @preset = Factory(:preset)
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
      response.should render_template('/presets/new')
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      create_preset
    end
    
    def do_get(format)
      get 'show', :id => @preset.id, :format => format
    end
    
    it "shows a preset as JSON" do
      do_get(:json)
      response.body.should == @preset.to_json
    end

    it "shows a preset as XML" do
      do_get(:xml)
      response.body.should == @preset.to_xml
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
end

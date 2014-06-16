require File.dirname(__FILE__) + '/../spec_helper'

describe PresetsController, :type => :controller do
  describe "GET 'index'" do
    before(:each) do
      allow(Preset).to receive(:all).and_return 'presets'
    end
    
    def do_get
      get 'index'
    end
    
    it "should find the presets" do
      expect(Preset).to receive(:all)
      do_get
    end
    
    it "should assign the presets for the view" do
      do_get
      expect(assigns[:presets]).to eq('presets')
    end
  end
  
  describe "GET 'new'" do
    before(:each) do
      @preset = double(Preset)
      allow(Preset).to receive(:new).and_return @preset
    end
    
    def do_get
      get 'new'
    end
    
    it "should generate a new preset" do
      expect(Preset).to receive(:new)
      do_get
    end
    
    it "should assign the new preset for the view" do
      do_get
      expect(assigns[:preset]).to eq(@preset)
    end
    
    it "should render the template" do
      do_get
      expect(response).to render_template('new')
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @preset = double(Preset)
      allow(Preset).to receive(:find).and_return @preset
    end
    
    def do_get
      get 'edit', :id => 1
    end
    
    it "should find the preset" do
      expect(Preset).to receive(:find).with('1')
      do_get
    end
    
    it "should assign the preset for the view" do
      do_get
      expect(assigns[:preset]).to eq(@preset)
    end
  end
end

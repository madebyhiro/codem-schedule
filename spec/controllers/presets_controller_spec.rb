require File.dirname(__FILE__) + '/../spec_helper'

describe PresetsController do
  describe "GET 'index'" do
    before(:each) do
      Preset.stub!(:all).and_return 'presets'
    end
    
    def do_get
      get 'index'
    end
    
    it "should find the presets" do
      Preset.should_receive(:all)
      do_get
    end
    
    it "should assign the presets for the view" do
      do_get
      assigns[:presets].should == 'presets'
    end
  end
  
  describe "GET 'new'" do
    before(:each) do
      @preset = mock_model(Preset)
      Preset.stub!(:new).and_return @preset
    end
    
    def do_get
      get 'new'
    end
    
    it "should generate a new preset" do
      Preset.should_receive(:new)
      do_get
    end
    
    it "should assign the new preset for the view" do
      do_get
      assigns[:preset].should == @preset
    end
    
    it "should render the template" do
      do_get
      response.should render_template('new')
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @preset = mock_model(Preset)
      Preset.stub!(:find).and_return @preset
    end
    
    def do_get
      get 'edit', :id => 1
    end
    
    it "should find the preset" do
      Preset.should_receive(:find).with('1')
      do_get
    end
    
    it "should assign the preset for the view" do
      do_get
      assigns[:preset].should == @preset
    end
  end
end

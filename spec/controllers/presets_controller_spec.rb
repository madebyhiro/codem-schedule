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
    it "should render the template" do
      get 'new'
      response.should render_template('new')
    end
  end
end

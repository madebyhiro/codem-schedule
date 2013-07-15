require 'spec_helper'

describe Preset do
  describe "generating a preset via the API" do
    it "should map the attributes correctly" do
      Preset.from_api({"name" => "name", "parameters" => "params", "thumbnail_options" => '{"seconds":1}'})
      p = Preset.last
      p.name.should == 'name'
      p.parameters.should == 'params'
      p.thumbnail_options.should == '{"seconds":1}'
    end
  end

  describe "validations" do
    it "should be valid with params and no thumb options" do
      p = Preset.new
      p.name = 'foo'
      p.parameters = 'bar'
      p.thumbnail_options = ''
      p.should be_valid
    end

    it "should be valid with thumb options and no params" do
      p = Preset.new
      p.name = 'foo'
      p.parameters = ''
      p.thumbnail_options = '{"seconds":1}'
      p.should be_valid
    end

    it "should not be valid without params and thumb options" do
      p = Preset.new
      p.name = 'foo'
      p.should_not be_valid
    end

    it "should not be valid with non-JSON thumbnail options" do
      p = Preset.new
      p.thumbnail_options = 'foo'
      p.should_not be_valid
      p.errors[:thumbnail_options].should == ['must be valid JSON']
    end
  end
end

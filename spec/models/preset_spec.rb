require 'spec_helper'

describe Preset do
  describe "generating a preset via the API" do
    it "should map the attributes correctly" do
      preset = Preset.from_api({"name" => "name", "parameters" => "params", "thumbnail_options" => "thumbs"})
      preset.name.should == 'name'
      preset.parameters.should == 'params'
      preset.thumbnail_options.should == 'thumbs'
    end
  end
end

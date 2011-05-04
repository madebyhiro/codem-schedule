require 'spec_helper'

describe Preset do
  describe "generating a preset via the API" do
    it "should map the attributes correctly" do
      preset = Preset.from_api({"name" => "name", "parameters" => "params"})
      preset.name.should == 'name'
      preset.parameters.should == 'params'
    end
  end
end

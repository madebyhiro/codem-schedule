require 'spec_helper'

describe Preset do
  context "validations" do
    before(:each) do
      @valid_attributes = {
        :name => 'name'
      }
      @preset = Preset.new
    end
    
    it "should be valid with all valid attributes" do
      @preset.attributes = @valid_attributes
      @preset.should be_valid
    end
    
    it "should not be valid without a name" do
      @preset.attributes = @valid_attributes.except(:name)
      @preset.should_not be_valid
    end
  end
end

require 'spec_helper'

describe Job do
  context "validations" do
    before(:each) do
      @valid_attributes = {
        :source_file => 'source',
        :destination_file => 'dest',
        :preset_id => 1
      }
      @job = Job.new
    end
    
    it "should be valid with all valid attributes" do
      @job.attributes = @valid_attributes
      @job.should be_valid
    end
    
    it "should not be valid without a source_file" do
      @job.attributes = @valid_attributes.except(:source_file)
      @job.should_not be_valid
    end

    it "should not be valid without a destination_file" do
      @job.attributes = @valid_attributes.except(:destination_file)
      @job.should_not be_valid
    end

    it "should not be valid without a preset" do
      @job.attributes = @valid_attributes.except(:preset_id)
      @job.should_not be_valid
    end
  end
end

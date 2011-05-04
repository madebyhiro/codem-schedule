require 'spec_helper'

describe Job do
  def create_job(attrs={})
    Job.create!({
      :source_file => 'source',
      :destination_file => 'dest',
      :preset_id => 1
    }.merge!(attrs))
  end
  
  describe "generating a job via the API" do
    before(:each) do
      @preset = Preset.create!(:name => 'preset', :parameters => 'params')
    end
    
    it "should map the attributes correctly" do
      job = Job.from_api({"input" => "input", "output" => "output", "preset" => "preset"})
      job.source_file.should == 'input'
      job.destination_file.should == 'output'
      job.preset.should == @preset
    end
  end
end

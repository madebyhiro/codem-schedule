require 'spec_helper'

describe Job do
  def create_job(attrs={})
    Job.create!({
      :source_file => 'source',
      :destination_file => 'dest',
      :preset_id => 1
    }.merge!(attrs))
  end
  
  context "generating a job via the API" do
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
  
  it "should set the initial state to scheduled" do
    Job.new.state.should == Job::Scheduled    
  end
  
  context "entering a state" do
    before(:each) do
      @job = create_job
    end
    
    it "should enter the specified state with parameters" do
      @job.should_receive(:enter_void).with(:foo => 'bar')
      @job.enter(:void, :foo => 'bar')
    end
  end
end

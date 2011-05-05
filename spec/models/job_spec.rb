require 'spec_helper'

describe Job do
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
  
  describe "updating a jobs status" do
    before(:each) do
      Transcoder.stub!(:job_status).and_return({ 'status' => 'foo', 'bar' => 'baz' })
      @job = Job.new
      @job.stub!(:enter).and_return true
    end
    
    def update
      @job.update_status
    end
    
    it "should ask the transcoder for the jobs status " do
      Transcoder.should_receive(:job_status).with(@job)
      update
    end
    
    it "should enter the correct state" do
      @job.should_receive(:enter).with('foo', { 'status' => 'foo', 'bar' => 'baz'})
      update
    end
    
    it "should return self" do
      update.should == @job
    end
  end
end

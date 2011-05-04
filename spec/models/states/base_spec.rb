require File.dirname(__FILE__) + '/../../spec_helper'

describe States::Base do
  before(:each) do
    @job = Job.create!(:source_file => 'source', :destination_file => 'dest', :preset_id => 1)
  end
  
  it "should set the initial state to scheduled" do
    Job.new.state.should == Job::Scheduled    
  end
  
  context "entering a state" do
    it "should enter the specified state with parameters" do
      @job.should_receive(:enter_void).with(:foo => 'bar')
      result = @job.enter(:void, :foo => 'bar')
      result.should == @job
    end
    
  end
  
  context "entering scheduled state" do
    it "should generate a new ScheduleJob" do
      Jobs::ScheduleJob.should_receive(:new).with(@job, :foo => 'bar').and_return mock("Job", :perform => true)
      @job.enter(:scheduled, :foo => 'bar')
    end
  end
  
  context "entering transcoding state" do
    before(:each) do
      @t = Time.new(2011, 1, 2, 3, 4, 5)
      Time.stub!(:current).and_return @t
    end
    
    def do_enter
      @job.enter(Job::Transcoding, { 'job_id' => 2 })
    end
    
    it "should set the parameters" do
      do_enter
      @job.remote_job_id.should == 2
      @job.transcoding_started_at.should == @t
      @job.state.should == Job::Transcoding
    end
  end
end
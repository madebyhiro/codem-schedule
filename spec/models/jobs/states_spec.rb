require File.dirname(__FILE__) + '/../../spec_helper'

describe Jobs::States do
  def headers
    { 'HTTP_X_CODEM_NOTIFY_TIMESTAMP' => 1 }
  end

  before(:each) do
    @job = FactoryGirl.create(:job)
    @job.stub(:notify_responders)
  end

  it "should set the initial state to scheduled" do
    Job.new.state.should == Job::Scheduled
    Job.new.initial_state.should == Job::Scheduled
  end

  it "should save the initial state to the db" do
    job = FactoryGirl.create(:job)
    job.enter(Job::Scheduled)
    job.state_changes.size.should == 1
    job.state_changes.last.state.should == job.initial_state
  end
  
  describe "entering a state" do
    def do_enter
      @job.stub(:enter_void)
      @job.enter(:void, {:foo => 'bar'}, headers)
    end
    
    it "should enter the specified state with parameters" do
      @job.should_receive(:enter_void).with(:foo => 'bar')
      do_enter
    end
    
    it "should return the job" do
      do_enter.should == @job
    end
  end
  
  describe "entering scheduled state" do
    def do_enter
      @job.enter(Job::Scheduled, {})
    end

    it "should generate 0 state changes if a state is present" do # job is already in Scheduled state
      do_enter
      lambda { do_enter; do_enter }.should change(@job.state_changes, :size).by(0)
    end
  end
  
  describe "entering accepted state" do
    before(:each) do
      @t = Time.new(2011, 1, 2, 3, 4, 5)
      Time.stub(:current).and_return @t
    end
    
    def do_enter
      @job.enter(Job::Accepted, { 'job_id' => 2 }, headers)
    end
    
    it "should set the parameters" do
      do_enter
      @job.remote_job_id.should == 2
      @job.transcoding_started_at.should == @t
      @job.state.should == Job::Accepted
    end
    
    it "should generate a state change" do
      do_enter
      @job.state_changes.last.state.should == Job::Accepted
    end

    it "should generate 1 state change" do
      lambda { do_enter; do_enter }.should change(@job.state_changes, :size).by(1)
    end
  end
  
  describe "entering processing state" do
    def do_enter
      @job.enter(Job::Processing, {'progress' => 1, 'duration' => 2, 'filesize' => 3}, headers)
    end
    
    it "should set the parameters" do
      do_enter
      @job.progress.should == 1
      @job.duration.should == 2
      @job.filesize.should == 3
    end
    
    it "should generate a state change" do
      do_enter
      @job.state_changes.last.state.should == Job::Processing
    end
    
    it "should generate 1 state change" do
      lambda { do_enter; do_enter }.should change(@job.state_changes, :size).by(1)
    end

    it "should send notifications" do
      @job.should_receive(:notify)
      do_enter
    end
  end
  
  describe "entering failed state" do
    def do_enter
      @job.enter(Job::Failed, {'message' => 'msg'})
    end
    
    it "should set the parameters" do
      do_enter
      @job.enter(Job::Scheduled)
      @job.message.should == 'msg'
    end
    
    it "should generate a state change" do
      do_enter
      change = @job.state_changes.last
      change.state.should == Job::Failed
      change.message.should == 'msg'
    end

    it "should send notifications" do
      @job.should_receive(:notify)
      do_enter
    end

    it "should generate 1 state change" do
      lambda { do_enter; do_enter }.should change(@job.state_changes, :size).by(1)
    end
  end
  
  describe "entering on hold state" do
    def do_enter
      @job.enter(Job::OnHold, {'message' => 'msg'})
    end

    it "should generate 1 state change" do
      lambda { do_enter; do_enter }.should change(@job.state_changes, :size).by(1)
    end
  end
  
  describe "entering success state" do
    before(:each) do
      @t = Time.new(2011, 1, 2, 3, 4, 5)
      Time.stub(:current).and_return @t
    end
    
    def do_enter
      @job.enter(Job::Success, {'message' => 'msg'}, headers)
    end
    
    it "should set the parameters" do
      do_enter
      @job.message.should == 'msg'
      @job.completed_at.should == @t
      @job.progress.should == 1.0
    end
    
    it "should generate a state change" do
      do_enter
      change = @job.state_changes.last
      change.state.should == Job::Success
      change.message.should == 'msg'
    end
    
    it "should send notifications" do
      @job.should_receive(:notify)
      do_enter
    end

    it "should generate 1 state change" do
      lambda { do_enter; do_enter }.should change(@job.state_changes, :size).by(1)
    end
  end
end

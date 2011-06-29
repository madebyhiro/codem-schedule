require File.dirname(__FILE__) + '/../spec_helper'

describe Runner do
  before(:each) do
    Job.destroy_all
    @job = Factory(:job)
  end

  def update
    Runner.schedule!
  end
  
  describe "entering scheduled state" do
    before(:each) do
      @host = Factory(:host)
      Host.stub!(:with_available_slots).and_return [@host]
      
      Transcoder.stub!(:schedule).and_return 'attrs'
    end
    
    it "should try to schedule the job at the host" do
      Transcoder.should_receive(:schedule).with(:host => @host, :job => @job)
      update
    end
    
    it "should enter accepted" do
      update
      @job.reload.state.should == Job::Accepted
    end
    
    it "should generate a state change" do
      update
      @job.state_changes.last.state.should == Job::Accepted
    end
    
    it "should stay scheduled if the job cannot be scheduled" do
      Transcoder.stub!(:schedule).and_return false
      update
      @job.state.should == Job::Scheduled
    end
  end

  describe "entering on hold state" do
    before(:each) do
      @host = double(Host, :available? => true, :update_status => true)
      @job.stub!(:host).and_return @host
      @job.stub!(:state).and_return Job::OnHold
    end
  
    it "should try to schedule the job" do
      Runner.should_receive(:schedule_job).with(@job)
      update
    end
  end

  describe "updating a jobs status" do
    before(:each) do
      Transcoder.stub!(:job_status).and_return({ 'status' => 'accepted', 'bar' => 'baz' })
    end

    it "should return the jobs" do
      update.should == [@job]
    end
    
    describe "as Scheduled" do
      before(:each) do
        @job.update_attributes :state => Job::Scheduled
      end
      
      it "should try to schedule the job" do
        Runner.should_receive(:schedule_job).with(@job)
        update
      end
    end
    
    describe "unfinished" do
      before(:each) do
        @job.update_attributes(:state => Job::Processing)
      end
      
      describe "success" do
        it "should ask the transcoder for the jobs status " do
          Transcoder.should_receive(:job_status).with(@job)
          update
        end
    
        it "should enter the correct state" do
          update
          @job.reload.state.should == Job::Accepted
        end
      end
      
      describe "failed" do
        before(:each) do
          Transcoder.should_receive(:job_status).with(@job).and_return false
        end
        
        it "should enter on hold" do
          update
          @job.reload.state.should == Job::OnHold
        end
      end
    end
    
    describe "finished" do
      before(:each) do
        @job.stub!(:finished?).and_return true
      end
      
      it "should not get the status" do
        Transcoder.should_not_receive(:job_status)
        update
      end
    end
  end
  
  describe "updating a single job status" do
    before(:each) do
      @job = Factory(:job)
    end
    
    def update
      Runner.update_progress(@job)
    end
    
    it "should do nothing if the job's state is not Processing" do
      updated_at = @job.updated_at
      update
      @job.updated_at.should == updated_at
    end
    
    describe "when the job is processing" do
      before(:each) do
        @job.update_attributes(:state => Job::Processing)
        @job.stub!(:enter_status)
        Transcoder.stub!(:job_status).and_return({'status' => 'status', 'foo' => 'bar'})
      end
      
      it "should request the status" do
        Transcoder.should_receive(:job_status).with(@job)
        update
      end
      
      it "should enter the correct status" do
        @job.should_receive(:enter).with('status', {'status' => 'status', 'foo' => 'bar'})
        update
      end
      
      it "should return the job" do
        update.should == @job
      end
    end
  end
end

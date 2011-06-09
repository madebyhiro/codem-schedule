require 'spec_helper'

describe Job do
  describe "generating a job via the API" do
    before(:each) do
      @preset = Factory(:preset)
    end

    describe "successfull save" do
      before(:each) do
        @job = Job.from_api({"input" => "input", "output" => "output", "preset" => @preset.name}, :callback_url => lambda { |job| "callback_#{job.id}" })
      end
      
      it "should map the attributes correctly" do
        @job.source_file.should == 'input'
        @job.destination_file.should == 'output'
        @job.preset.should == @preset
        @job.callback_url.should == "callback_#{@job.id}"
      end
      
      it "should be saved" do
        @job.should_not be_new_record
      end
    
      it "should be in the scheduled state" do
        @job.state.should == Job::Scheduled
      end
    end
    
    describe "failed save" do
      before(:each) do
        @job = Job.from_api({}, {})
      end
      
      it "should not be saved" do
        @job.should be_new_record
      end
    end
  end
  
  describe "updating a jobs status" do
    before(:each) do
      Transcoder.stub!(:job_status).and_return({ 'status' => 'foo', 'bar' => 'baz' })
      @job = Job.new(:state => Job::Processing)
      @job.stub!(:enter).and_return true
    end
    
    def update
      @job.update_status
    end
    
    describe "as Scheduled" do
      before(:each) do
        @job.update_attributes :state => Job::Scheduled
      end
      
      it "should re-enter scheduled" do
        @job.should_receive(:enter).with(Job::Scheduled)
        update
      end
    end
    
    describe "unfinished" do
      describe "success" do
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
      
      describe "failed" do
        before(:each) do
          Transcoder.stub!(:job_status).and_return false
        end
        
        it "should enter on hold" do
          @job.should_receive(:enter).with(Job::OnHold)
          update
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
      
      it "should return self" do
        update.should == @job
      end
    end
  end

  describe "finished" do
    it "should be finished if Success" do
      Job.new(:state => Job::Success).should be_finished
    end

    it "should be finished if Failed" do
      Job.new(:state => Job::Failed).should be_finished
    end
  end
  
  describe "unfinished" do
    it "should be unfinished if Scheduled" do
      Job.new(:state => Job::Scheduled).should be_unfinished
    end

    it "should be unfinished if Accepted" do
      Job.new(:state => Job::Accepted).should be_unfinished
    end

    it "should be unfinished if Processing" do
      Job.new(:state => Job::Processing).should be_unfinished
    end

    it "should be unfinished if Processing" do
      Job.new(:state => Job::OnHold).should be_unfinished
    end
  end
  
  describe "needs update" do
    it "should need an update if Accepted" do
      Job.new(:state => Job::Accepted).should be_needs_update
    end

    it "should need an update if Processing" do
      Job.new(:state => Job::Processing).should be_needs_update
    end
    
    it "should need an update if OnHold" do
      Job.new(:state => Job::OnHold).should be_needs_update
    end
  end
  
  describe "getting the recent jobs" do
    before(:each) do
      @job = double(Job)
      Job.stub_chain(:recent, :page).and_return [@job]
    end
    
    def recents
      Job.recents
    end
    
    it "should fetch the recent jobs" do
      Job.should_receive(:recent)
      recents
    end
    
    it "should return the jobs" do
      recents.should == [@job]
    end
  end
end

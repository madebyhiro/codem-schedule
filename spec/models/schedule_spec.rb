require File.dirname(__FILE__) + '/../spec_helper'

describe Schedule do
  before do
    Job.destroy_all
    Host.stub(:all).and_return []
    Transcoder.stub(:job_status).and_return {}
  end

  def update
    Schedule.run!
  end
  
  describe "scheduling jobs" do
    let!(:job) { FactoryGirl.create(:job) }
    let(:host) { FactoryGirl.create(:host) }

    before do
      Schedule.stub(:get_available_slots).and_return 10
      Host.stub(:with_available_slots).and_return [host]
      Transcoder.stub(:schedule).and_return 'attrs'
    end

    def run
      Schedule.run!
    end

    it "should try to schedule the job" do
      Transcoder.should_receive(:schedule).with(:host => host, :job => job)
      update
    end
    
    it "should enter processing" do
      run
      job.reload.state.should == Job::Processing
    end
    
    it "should generate a state change" do
      run
      job.state_changes.last.state.should == Job::Processing
    end
    
    it "should stay scheduled if the job cannot be scheduled" do
      Transcoder.stub(:schedule).and_return false
      run
      job.reload.state.should == Job::Scheduled
    end
  end

  describe "entering on hold state" do
    let!(:job)  { FactoryGirl.create(:job) }
    let(:host) { FactoryGirl.create(:host) }

    before(:each) do
      Schedule.stub(:get_available_slots).and_return 10

      host = double(Host, :available? => true, :update_status => true)
      job.stub(:host).and_return host
      job.stub(:state).and_return Job::OnHold
    end
  
    it "should try to schedule the job" do
      Schedule.should_receive(:schedule_job).with(job)
      update
    end

    it 'should enter on hold' do
      update
      job.state.should == Job::OnHold
    end
  end

  describe "updating a jobs status" do
    let!(:job) { FactoryGirl.create(:job) }

    before do
      Schedule.stub(:get_available_slots).and_return 10
      Transcoder.stub(:job_status).and_return({ 'status' => 'processing', 'bar' => 'baz' })
    end

    it "should return the number of updated jobs" do
      Schedule.stub(:to_be_updated_jobs).and_return [ job ]
      update.should == 1
    end
    
    describe "as Scheduled" do
      before do
        job.update_attributes :state => Job::Scheduled
      end
      
      it "should try to schedule the job" do
        Schedule.should_receive(:schedule_job).with(job)
        update
      end
    end
    
    describe "unfinished" do
      before do
        job.update_attributes(:state => Job::Processing)
      end
      
      describe "success" do
        it "should ask the transcoder for the jobs status " do
          Transcoder.should_receive(:job_status).with(job)
          update
        end
    
        it "should enter the correct state" do
          update
          job.reload.state.should == Job::Processing
        end

        it "should update the progress if the transcoder is processing" do
          attrs = { 'status' => Job::Processing }
          Transcoder.stub(:job_status).and_return attrs
          update
        end
      end

      describe 'other states' do
        let!(:job) { FactoryGirl.create(:job) }

        before do
          Transcoder.stub(:job_status).and_return({ 'status' => 'success', 'message' => 'bar' })
        end

        it 'should enter the correct state' do
          update
          job.reload
          job.state.should == Job::Success
          job.message.should == 'bar'
        end
      end
      
      describe "failed" do
        let(:job) { FactoryGirl.create(:job) }

        before(:each) do
          Transcoder.should_receive(:job_status).with(job).and_return false
        end
        
        it "should enter on hold" do
          update
          job.reload.state.should == Job::OnHold
        end
      end
    end
    
    describe "finished" do
      before(:each) do
        job.stub(:finished?).and_return true
      end
      
      it "should not get the status" do
        Transcoder.should_not_receive(:job_status)
        update
      end
    end
  end
  
  describe "updating a single job status" do
    let(:job) { FactoryGirl.create(:job) }
    
    def update
      Schedule.update_progress(job)
    end
    
    it "should do nothing if the job's state is not Processing" do
      updated_at = job.updated_at
      update
      job.updated_at.should == updated_at
    end

    describe "when the job is processing" do
      before(:each) do
        job.update_attributes(:state => Job::Processing)
        job.stub(:enter_status)
        Transcoder.stub(:job_status).and_return({'status' => 'status', 'foo' => 'bar'})
      end
      
      it "should request the status" do
        Transcoder.should_receive(:job_status).with(job)
        update
      end
     
      it "should not re-enter processing" do
        job.should_not_receive(:enter)
        update
      end

      it "should update the status" do
        Schedule.should_receive(:update_progress).with(job).and_return true
        update
      end
      
      it "should return the job" do
        update.should == job
      end
    end
  end

  describe "returning the number of available slots" do
    def slots
      Schedule.get_available_slots
    end

    it "should return 0 when no hosts are added" do
      Host.stub(:all).and_return []
      slots.should == 0
    end

    it "should sum the available slots of all hosts" do
      host = double(Host, :update_status => true, :available_slots => 10)
      Host.stub(:all).and_return [host]
      slots.should == 10
    end
  end
end

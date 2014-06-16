require File.dirname(__FILE__) + '/../spec_helper'

describe Schedule, type: :model do
  before do
    Job.destroy_all
    allow(Host).to receive(:all).and_return []
    allow(Transcoder).to receive(:job_status) {}
  end

  def update
    Schedule.run!
  end

  describe 'scheduling jobs' do
    let!(:job) { FactoryGirl.create(:job) }
    let(:host) { FactoryGirl.create(:host) }

    before do
      allow(Schedule).to receive(:available_slots).and_return 10
      allow(Host).to receive(:with_available_slots).and_return [host]
      allow(Transcoder).to receive(:schedule).and_return 'attrs'
    end

    def run
      Schedule.run!
    end

    it 'should try to schedule the job' do
      expect(Transcoder).to receive(:schedule).with(host: host, job: job)
      update
    end

    it 'should enter processing' do
      run
      expect(job.reload.state).to eq(Job::Processing)
    end

    it 'should generate a state change' do
      run
      expect(job.state_changes.last.state).to eq(Job::Processing)
    end

    it 'should stay scheduled if the job cannot be scheduled' do
      allow(Transcoder).to receive(:schedule).and_return false
      run
      expect(job.reload.state).to eq(Job::Scheduled)
    end
  end

  describe 'entering on hold state' do
    let!(:job)  { FactoryGirl.create(:job) }
    let(:host) { FactoryGirl.create(:host) }

    before(:each) do
      allow(Schedule).to receive(:available_slots).and_return 10

      host = double(Host, :available? => true, :update_status => true)
      allow(job).to receive(:host).and_return host
      allow(job).to receive(:state).and_return Job::OnHold
    end

    it 'should try to schedule the job' do
      expect(Schedule).to receive(:schedule_job).with(job)
      update
    end

    it 'should enter on hold' do
      update
      expect(job.state).to eq(Job::OnHold)
    end
  end

  describe 'updating a jobs status' do
    let!(:job) { FactoryGirl.create(:job) }

    before do
      allow(Schedule).to receive(:available_slots).and_return 10
      allow(Transcoder).to receive(:job_status).and_return('status' => 'processing', 'bar' => 'baz')
    end

    it 'should return the number of updated jobs' do
      allow(Schedule).to receive(:to_be_updated_jobs).and_return [job]
      expect(update).to eq(1)
    end

    describe 'as Scheduled' do
      before do
        job.update_attributes state: Job::Scheduled
      end

      it 'should try to schedule the job' do
        expect(Schedule).to receive(:schedule_job).with(job)
        update
      end
    end

    describe 'unfinished' do
      before do
        job.update_attributes(state: Job::Processing)
      end

      describe 'success' do
        it 'should ask the transcoder for the jobs status ' do
          expect(Transcoder).to receive(:job_status).with(job)
          update
        end

        it 'should enter the correct state' do
          update
          expect(job.reload.state).to eq(Job::Processing)
        end

        it 'should update the progress if the transcoder is processing' do
          attrs = { 'status' => Job::Processing }
          allow(Transcoder).to receive(:job_status).and_return attrs
          update
        end
      end

      describe 'other states' do
        let!(:job) { FactoryGirl.create(:job) }

        before do
          allow(Transcoder).to receive(:job_status).and_return('status' => 'success', 'message' => 'bar')
        end

        it 'should enter the correct state' do
          update
          job.reload
          expect(job.state).to eq(Job::Success)
          expect(job.message).to eq('bar')
        end
      end

      describe 'failed' do
        let(:job) { FactoryGirl.create(:job) }

        before(:each) do
          expect(Transcoder).to receive(:job_status).with(job).and_return false
        end

        it 'should enter on hold' do
          update
          expect(job.reload.state).to eq(Job::OnHold)
        end
      end
    end

    describe 'finished' do
      before(:each) do
        allow(job).to receive(:finished?).and_return true
      end

      it 'should not get the status' do
        expect(Transcoder).not_to receive(:job_status)
        update
      end
    end
  end

  describe 'returning the number of available slots' do
    def slots
      Schedule.available_slots
    end

    it 'should return 0 when no hosts are added' do
      allow(Host).to receive(:all).and_return []
      expect(slots).to eq(0)
    end

    it 'should sum the available slots of all hosts' do
      host = double(Host, update_status: true, available_slots: 10)
      allow(Host).to receive(:all).and_return [host]
      expect(slots).to eq(10)
    end
  end
end

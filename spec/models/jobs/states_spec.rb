require File.dirname(__FILE__) + '/../../spec_helper'

describe Jobs::States, type: :model do
  def headers
    { 'HTTP_X_CODEM_NOTIFY_TIMESTAMP' => 1 }
  end

  let(:job) { FactoryGirl.create(:job) }

  it 'should set the initial state to scheduled' do
    expect(job.state).to eq(Job::Scheduled)
    expect(Job.new.initial_state).to eq(Job::Scheduled)
  end

  it 'should save the initial state to the db' do
    job.reload
    job.save!
    expect(job.state_changes.size).to eq(1)
    expect(job.state_changes.last.state).to eq(job.initial_state)
  end

  describe 'entering a state' do
    def do_enter
      allow(job).to receive(:enter_void)
      job.enter(:void, { foo: 'bar' }, headers)
    end

    it 'should enter the specified state with parameters' do
      expect(job).to receive(:enter_void).with(foo: 'bar')
      do_enter
    end

    it 'should return the job' do
      expect(do_enter).to eq(job)
    end
  end

  describe 'entering scheduled state' do
    let(:job) { FactoryGirl.create(:job) }

    def do_enter
      job.enter(Job::Scheduled, {})
    end

    it 'should generate 0 state changes if a state is present' do # job is already in Scheduled state
      do_enter
      expect { do_enter && do_enter }.to change(job.state_changes, :size).by(0)
    end
  end

  describe 'entering processing state' do
    let(:job) { FactoryGirl.create(:job) }

    def do_enter
      job.enter(Job::Processing,  'progress' => 1, 'duration' => 2, 'filesize' => 3)
    end

    it 'should set the parameters' do
      do_enter
      expect(job.progress).to eq(1)
      expect(job.duration).to eq(2)
      expect(job.filesize).to eq('3')
    end

    it 'should generate a state change' do
      do_enter
      expect(job.reload.state_changes.last.state).to eq(Job::Processing)
    end

    it 'should generate 1 state change' do
      expect { do_enter && do_enter }.to change(job.state_changes, :size).by(1)
    end

    it 'should send notifications' do
      expect(job).to receive(:notify)
      do_enter
    end
  end

  describe 'entering failed state' do
    let(:job) { FactoryGirl.create(:job) }

    def do_enter
      job.enter(Job::Failed, { 'message' => 'msg' }, headers)
      job.reload
    end

    it 'should set the state' do
      do_enter
      expect(job.state).to eq(Job::Failed)
    end

    it 'should set the parameters' do
      do_enter
      expect(job.reload.message).to eq('msg')
    end

    it 'should generate a state change' do
      do_enter
      change = job.state_changes.last
      expect(change.state).to eq(Job::Failed)
      expect(change.message).to eq('msg')
    end

    it 'should send notifications' do
      expect(job).to receive(:notify)
      do_enter
    end

    it 'should generate 1 state change' do
      expect { do_enter && do_enter }.to change(job.state_changes, :size).by(1)
    end
  end

  describe 'entering on hold state' do
    def do_enter
      job.enter(Job::OnHold,  'message' => 'msg')
    end

    it 'should generate 1 state change' do
      expect { do_enter && do_enter }.to change(job.state_changes, :size).by(1)
    end
  end

  describe 'entering success state' do
    before(:each) do
      @t = Time.new(2011, 1, 2, 3, 4, 5)
      allow(Time).to receive(:current).and_return @t
    end

    def do_enter
      job.enter(Job::Success,  'message' => 'msg')
    end

    it 'should set the parameters' do
      do_enter
      expect(job.message).to eq('msg')
      expect(job.completed_at).to eq(@t)
      expect(job.progress).to eq(1.0)
    end

    it 'should generate a state change' do
      do_enter
      change = job.state_changes.last
      expect(change.state).to eq(Job::Success)
      expect(change.message).to eq('msg')
    end

    it 'should send notifications' do
      expect(job).to receive(:notify)
      do_enter
    end

    it 'should generate 1 state change' do
      expect { do_enter && do_enter }.to change(job.state_changes, :size).by(1)
    end
  end
end

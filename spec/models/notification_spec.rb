require 'spec_helper'

describe Notification, type: :model do
  describe 'creating via the API' do
    it 'should return [] without parameters' do
      expect(Notification.from_api).to eq([])
    end

    it 'should return an EmailNotification if the options include an email' do
      expect(EmailNotification).to receive(:new).with(value: 'foo@bar.com').and_return 'notification'
      expect(Notification.from_api('foo@bar.com')).to eq(['notification'])
    end

    it 'should return an UrlNotification if the options include an url' do
      expect(UrlNotification).to receive(:new).with(value: 'foo.com').and_return 'notification'
      expect(Notification.from_api('foo.com')).to eq(['notification'])
    end

    it 'should return a notification for each option' do
      expect(EmailNotification).to receive(:new).with(value: 'foo@bar.com').and_return 'email'
      expect(UrlNotification).to receive(:new).with(value: 'foo.com').and_return 'url'
      expect(Notification.from_api('foo@bar.com,foo.com')).to eq(%w(email url))
    end

    it 'should handle spaces' do
      expect(EmailNotification).to receive(:new).with(value: 'foo@bar.com').and_return 'email'
      expect(Notification.from_api(' foo@bar.com ')).to eq(['email'])
    end
  end

  it 'should return the correct name' do
    expect(EmailNotification.new.name).to eq('Email')
    expect(UrlNotification.new.name).to eq('Url')
  end

  it 'should have the correct initial state' do
    expect(Notification.new.initial_state).to eq(Job::Scheduled)
    expect(Notification.new.state).to eq(Job::Scheduled)
  end

  describe 'when notifying' do
    before(:each) do
      @t = Time.new(2011, 1, 2, 3, 4, 5)
      allow(Time).to receive(:now).and_return @t
      @job = FactoryGirl.create(:job, state_changes: [StateChange.new(state: Job::Scheduled)])
      @not = Notification.create!(job: @job)
      allow(@not).to receive(:do_notify!)
    end

    def do_notify
      @not.notify!('args')
    end

    it 'should perform the notification' do
      expect(@not).to receive(:notify!).with('args')
      do_notify
    end

    it 'should set the notified at for the last delivery' do
      do_notify
      expect(@not.deliveries.last.notified_at).to eq(@t)
    end

    it 'should return self' do
      expect(do_notify).to eq(@not)
    end

    describe 'success' do
      before(:each) do
        allow(@not).to receive(:do_notify!).and_return true
      end

      it 'should update the status of the delivery to success' do
        do_notify
        expect(@not.deliveries.last.state).to eq(Job::Success)
      end
    end

    describe 'failed' do
      before(:each) do
        allow(@not).to receive(:do_notify!).and_raise 'Foo'
      end

      it 'should update the status of the delivery to failed' do
        do_notify
        expect(@not.deliveries.last.state).to eq(Job::Failed)
      end
    end
  end
end

require 'spec_helper'

describe Emailer, type: :mailer do
  before(:each) do
    @job = double(Job, id: 1, state: 'state', message: 'message')
  end

  def do_send
    Emailer.state_change(job: @job, to: 'to', state: 'state')
  end

  it 'should render successfully' do
    expect { do_send }.not_to raise_error
  end

  describe 'successfull render' do
    before(:each) do
      @mailer = do_send
    end

    it 'should render the state' do
      expect(@mailer.body).to include("Job #{@job.id} has entered state: message")
    end

    it 'should deliver successfully' do
      expect { @mailer.deliver_now }.not_to raise_error
    end

    describe 'and delivered' do
      it 'should be added to the delivery queue' do
        expect { @mailer.deliver_now }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end

  end

end

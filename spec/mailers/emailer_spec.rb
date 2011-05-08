require "spec_helper"

describe Emailer do
  before(:each) do
    @job = double(Job, :id => 1, :state => 'state', :message => 'message')
  end
  
  def do_send
    Emailer.state_change(:job => @job, :to => 'to', :state => 'state')
  end
  
  it "should render successfully" do
    lambda { do_send }.should_not raise_error
  end
  
  describe "successfull render" do
    before(:each) do
      @mailer = do_send
    end
    
    it "should render the state" do
      @mailer.body.should include("Job #{@job.id} has entered state: message")
    end
    
    it "should deliver successfully" do
      lambda { @mailer.deliver }.should_not raise_error
    end

    describe "and delivered" do
      it "should be added to the delivery queue" do
        lambda { @mailer.deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
      end
    end

  end
  
end

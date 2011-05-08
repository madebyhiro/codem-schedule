require File.dirname(__FILE__) + '/../spec_helper'

describe EmailNotification do
  it "should send a mail" do
    job = Job.new
    email = mock("Email")
    email.should_receive(:deliver)
    Emailer.should_receive(:state_change).with(:job => job, :state => 'state', :to => 'value').and_return email
    EmailNotification.new(:value => 'value').notify!(:job => job, :state => 'state')
  end
end

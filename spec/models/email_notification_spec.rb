require File.dirname(__FILE__) + '/../spec_helper'

describe EmailNotification do
  it "should send a mail" do
    st = StateChange.new(:state => 'foo')
    job = FactoryGirl.create(:job, :state_changes => [st])
    email = mock("Email")
    email.should_receive(:deliver)
    Emailer.should_receive(:state_change).with(:job => job, :state => 'state', :to => 'value').and_return email
    EmailNotification.new(:value => 'value').do_notify!(:job => job, :state => 'state')
  end
end

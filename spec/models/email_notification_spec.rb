require File.dirname(__FILE__) + '/../spec_helper'

describe EmailNotification, :type => :model do
  it "should send a mail" do
    st = StateChange.new(:state => 'foo')
    job = FactoryGirl.create(:job, :state_changes => [st])
    email = double("Email")
    expect(email).to receive(:deliver)
    expect(Emailer).to receive(:state_change).with(:job => job, :state => 'state', :to => 'value').and_return email
    EmailNotification.new(:value => 'value').do_notify!(:job => job, :state => 'state')
  end
end

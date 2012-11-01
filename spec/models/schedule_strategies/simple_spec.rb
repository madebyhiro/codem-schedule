require 'spec_helper'

describe ScheduleStrategies::Simple do
  def strategy
    ScheduleStrategies::Simple.new('job')
  end

  it "should return the correct hosts" do
    Host.should_receive(:with_available_slots).and_return 'hosts'
    strategy.hosts.should == 'hosts'
  end
end


require 'spec_helper'

describe ScheduleStrategies::Weighted do
  def strategy
    ScheduleStrategies::Weighted.new
  end

  before(:each) do
    @host1 = double("Host 1")
    @host2 = double("Host 2")
    @host3 = double("Host 3")

    ScheduleStrategies::Simple.any_instance.stub(:hosts).and_return [ @host1, @host2, @host3 ]
  end

  it "should not re-sort the hosts if they all have the same weight" do
    @host1.stub!(:weight).and_return 5
    @host2.stub!(:weight).and_return 5
    @host3.stub!(:weight).and_return 5

    strategy.hosts.should == [ @host1, @host2, @host3 ]
  end

  it "should sort the hosts on (weight / available_slots) if the hosts have different weights" do
    @host1.stub!(:weight).and_return 25
    @host2.stub!(:weight).and_return 50
    @host3.stub!(:weight).and_return 50

    @host1.stub!(:available_slots).and_return 10
    @host2.stub!(:available_slots).and_return  5
    @host3.stub!(:available_slots).and_return  8

    strategy.hosts.should == [ @host2, @host3, @host1 ]
  end
end

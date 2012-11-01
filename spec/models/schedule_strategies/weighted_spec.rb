require 'spec_helper'

describe ScheduleStrategies::Weighted do
  def strategy
    ScheduleStrategies::Weighted.new('job')
  end

  before(:each) do
    @job = double("Job")

    @host1 = double("Host 1", weight: 0, available_slots: 4)
    @host2 = double("Host 2", weight: 0, available_slots: 4)

    Host.stub!(:with_available_slots).and_return [ @host1, @host2 ]
  end

  describe "given all hosts have 0 as weight, " do
    it "hosts should be sorted with most available slots first" do
      @host1.stub!(:available_slots).and_return 5
      @host2.stub!(:available_slots).and_return 10

      strategy.hosts.should == [ @host2, @host1 ]
    end
  end

  describe "given some hosts have 0 as weight, " do
    it "hosts with weight 0 should be last" do
      @host2.stub!(:weight).and_return 5

      strategy.hosts.should == [ @host2, @host1 ]
    end
  end
end


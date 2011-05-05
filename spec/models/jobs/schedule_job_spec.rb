require File.dirname(__FILE__) + '/../../spec_helper'

describe Jobs::ScheduleJob do
  before(:each) do
    @host    = Factory(:host)
    @subject = Factory(:job)
    @job     = Jobs::ScheduleJob.new(@subject)
    
    Host.stub!(:with_available_slots).and_return [@host]
    Transcoder.stub!(:schedule)
  end
  
  def perform
    @job.perform
  end
  
  it "should try to schedule the job at available hosts" do
    Host.should_receive(:with_available_slots).and_return [@host]
    Transcoder.should_receive(:schedule).with(:host => @host, :job => @subject)
    perform
  end
  
  describe "successfull schedule" do
    before(:each) do
      Transcoder.stub!(:schedule).and_return true
    end
    
    it "should not reschdule" do
      @job.should_not_receive(:reschedule)
      perform
    end
  end

  describe "failed schedule" do
    before(:each) do
      Transcoder.stub!(:schedule).and_return false
    end
    
    it "should reschdule" do
      @job.should_receive(:reschedule)
      perform
    end
  end
end

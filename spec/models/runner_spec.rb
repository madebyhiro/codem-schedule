require File.dirname(__FILE__) + '/../spec_helper'

describe Runner do
  it "should return the correct jobs to consider" do
    @job1 = Factory(:job, :state => Job::Scheduled, :created_at => 2.days.ago)
    @job2 = Factory(:job, :state => Job::OnHold, :created_at => 5.days.ago)
    
    Runner.jobs.should == [@job2, @job1]
  end
  
  it "should process the correct jobs" do
    job = double(Job)
    Runner.stub!(:jobs).and_return [job]
    
    job.should_receive(:update_status).and_return 'updated'
    Runner.schedule!.should == ['updated']
  end
end

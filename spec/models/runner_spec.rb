require File.dirname(__FILE__) + '/../spec_helper'

describe Runner do
  it "should return the correct jobs to consider" do
    Job.stub!(:scheduled).and_return ['scheduled']
    Job.stub!(:on_hold).and_return ['on_hold']
    Job.stub!(:processing).and_return ['processing']
    
    Runner.jobs.should == ['scheduled', 'on_hold', 'processing']
  end
  
  it "should process the correct jobs" do
    job = double(Job, :state => 'state', :enter => true)
    Runner.stub!(:jobs).and_return [job]
    
    job.should_receive(:enter).with('state')
    Runner.schedule!
  end
end

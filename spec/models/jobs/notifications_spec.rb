require File.dirname(__FILE__) + '/../../spec_helper'

describe Jobs::Notifications do
  it "should have the logger as default responders" do
    resp = Jobs::Notifications.default_responders
    resp.size.should == 1
    resp.first.should be_a(Jobs::Notifiers::Logger)
  end
  
  it "should add the default responders as responders" do
    resp = Job.new.responders
    resp.size.should == 1
    resp.first.should be_a(Jobs::Notifiers::Logger)
  end
  
  describe "adding responders" do
    before(:each) do
      @job = Job.new
    end
    
    it "should add a responder for :all by default" do
      @job.add_responder('foo')
      @job.responders.last.should == ['foo', :all]  
    end

    it "should allow overriding which states to respond to" do
      @job.add_responder('foo', 'state')
      @job.responders.last.should == ['foo', 'state']
    end
  end
  
  describe "notifying responders" do
    before(:each) do
      @job = Job.new
      @all_responder = mock("Responding to all", :notify => true)
      @foo_responder = mock("Responding only to foo", :notify => true)
      @job.responders = [[@all_responder, :all], [@foo_responder, :foo]]
    end
    
    def notify(state)
      @job.stub!(:state).and_return state
      @job.notify_responders
    end
    
    it "should notify a responder for :all for any given state" do
      @all_responder.should_receive(:notify).with('bar', @job)
      notify('bar')
    end
    
    it "should not notify a responder responding to foo for state bar" do
      @foo_responder.should_not_receive(:notify)
      notify('bar')
    end
    
    it "should notify a responder responding to foo for state foo" do
      @foo_responder.should_receive(:notify).with('foo', @job)
      notify('foo')
    end
  end
  
  it "should log an error if notification failed" do
    job = Job.new
    res = mock("Responder")
    res.should_receive(:notify).and_raise "Foo"
    job.responders = [ [res, :all] ]

    Rails.logger.should_receive(:warn).at_least(1)
        
    job.notify_responders
  end
end

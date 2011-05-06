require File.dirname(__FILE__) + '/../../../spec_helper'

describe Jobs::Notifiers::Logger do
  it "should set a sensible default log path" do
    Jobs::Notifiers::Logger.log_file_path.should == File.join(Rails.root, 'log', "#{Rails.env}_job_notifier.log")
  end
  
  it "should be enabled by default" do
    Jobs::Notifiers::Logger.logging_enabled.should be_true
  end
  
  describe "when notifying of a state change" do
    before(:each) do
      @notifier = Jobs::Notifiers::Logger.new
      @job = double(Job)
    end
    
    def notify
      @notifier.notify('state', @job)
    end
    
    describe "logging enabled" do
      it "should format the message" do
        @notifier.should_receive(:format_log_message).with('state', @job)
        notify
      end
      
      it "should log the message" do
        @notifier.stub!(:format_log_message).and_return 'message'
        @notifier.should_receive(:log).with('message')
        notify
      end
    end
    
    describe "logging disabled" do
      before(:each) do
        Jobs::Notifiers::Logger.logging_enabled = false
      end
      
      it "should not log" do
        @notifier.should_not_receive(:log)
        notify
      end
    end
  end
  
  it "should format the message correctly" do
    job = double(Job, :id => 1)
    Time.stub!(:now).and_return Time.utc(2011, 01, 02, 03, 04, 05)
    notifier = Jobs::Notifiers::Logger.new
    notifier.format_log_message('foo', job).should == "2011-01-02 03:04:05 UTC: Job 1 entered state Foo"
  end
  
  it "should initialize the correct logger" do
    ::Logger.should_receive(:new).with('/tmp/path').and_return 'logger'
    Jobs::Notifiers::Logger.log_file_path = '/tmp/path'
    Jobs::Notifiers::Logger.new.logger.should == 'logger'
  end
end

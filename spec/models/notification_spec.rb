require 'spec_helper'

describe Notification do
  describe "creating via the API" do
    it "should return [] without parameters" do
      Notification.from_api.should == []
    end
    
    it "should return an EmailNotification if the options include an email" do
      EmailNotification.should_receive(:new).with(:value => 'foo@bar.com').and_return 'notification'
      Notification.from_api('foo@bar.com').should == ['notification']
    end

    it "should return an UrlNotification if the options include an url" do
      UrlNotification.should_receive(:new).with(:value => 'foo.com').and_return 'notification'
      Notification.from_api('foo.com').should == ['notification']
    end
    
    it "should return a notification for each option" do
      EmailNotification.should_receive(:new).with(:value => 'foo@bar.com').and_return 'email'
      UrlNotification.should_receive(:new).with(:value => 'foo.com').and_return 'url'
      Notification.from_api('foo@bar.com,foo.com').should == ['email', 'url']
    end
    
    it "should handle spaces" do
      EmailNotification.should_receive(:new).with(:value => 'foo@bar.com').and_return 'email'
      Notification.from_api(' foo@bar.com ').should == ['email']
    end
  end
  
  it "should return the correct name" do
    EmailNotification.new.name.should == 'Email'
    UrlNotification.new.name.should   == 'Url'
  end
  
  it "should have the correct initial state" do
    Notification.new.initial_state.should == Job::Scheduled
    Notification.new.state.should == Job::Scheduled
  end
  
  describe "when notifying" do
    before(:each) do
      @t = Time.new(2011, 1, 2, 3, 4, 5)
      Time.stub!(:now).and_return @t
      @not = Notification.new
      @not.stub!(:do_notify!)
    end
    
    def do_notify
      @not.notify!('args')
    end

    it "should perform the notification" do
      @not.should_receive(:notify!).with('args')
      do_notify
    end
    
    it "should set the notified at" do
      do_notify
      @not.notified_at.should == @t
    end
    
    it "should return self" do
      do_notify.should == @not
    end
    
    describe "success" do
      before(:each) do
        @not.stub!(:do_notify!).and_return true
      end
      
      it "should update the status to success" do
        do_notify
        @not.state.should == Job::Success
      end
    end
    
    describe "failed" do
      before(:each) do
        @not.stub!(:do_notify!).and_raise "Foo"
      end

      it "should update the status to failed" do
        do_notify
        @not.state.should == Job::Failed
      end
    end
  end
end

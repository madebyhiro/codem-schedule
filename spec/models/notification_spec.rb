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
  end
end

require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::NotificationsController, :type => :controller do
  describe "GET 'index'" do
    before(:each) do
      @job = FactoryGirl.create(:job)
      @job.notifications << EmailNotification.new(:value => 'email')
      @job.notifications << UrlNotification.new(:value => 'url')
    end

    def do_get(format)
      get 'index', :id => @job.id, :format => format
    end

    it "shows notifications as json" do
      do_get(:json)
      expect(response.body).to eq(@job.notifications.to_json)
    end

    it "shows notifications as xml" do
      do_get(:xml)
      expect(response.body).to eq(@job.notifications.to_xml)
    end
  end
end

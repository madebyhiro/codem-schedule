require File.dirname(__FILE__) + '/../spec_helper'

describe UrlNotification, :type => :model do
  it "should post to an url" do
    expect(RestClient).to receive(:post).with('url', 'attrs')
    UrlNotification.new(:value => 'url').do_notify!(:job => double("Job", :attributes => 'attrs'))
  end
end

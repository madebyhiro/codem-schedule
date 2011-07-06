require File.dirname(__FILE__) + '/../spec_helper'

describe UrlNotification do
  it "should post to an url" do
    URI.should_receive(:parse).with('value').and_return 'url'
    Net::HTTP.should_receive(:post_form).with('url', 'attrs')
    UrlNotification.new(:value => 'value').do_notify!(:job => mock("Job", :attributes => 'attrs'))
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  it "should set the title correctly" do
    should_receive(:content_for).with(:title)
    title('foo')
  end
end

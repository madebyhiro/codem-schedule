require File.dirname(__FILE__) + '/../spec_helper'

describe HostsHelper do
  describe "host_name" do
    it "should return nil without a host" do
      host_name(nil).should be_nil
    end
    
    it "should return the url without a name" do
      host_name(Host.new(:url => 'url')).should == 'url'
    end
    
    it "should return a formatted string with a name and url" do
      host_name(Host.new(:name => 'name', :url => 'url')).should == 'name (<span class="address">url</span>)'
    end
  end
end

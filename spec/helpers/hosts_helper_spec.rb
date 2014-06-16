require File.dirname(__FILE__) + '/../spec_helper'

describe HostsHelper, :type => :helper do
  describe "host_name" do
    it "should return nil without a host" do
      expect(host_name(nil)).to be_nil
    end
    
    it "should return the url without a name" do
      expect(host_name(Host.new(:url => 'url'))).to eq('url')
    end
    
    it "should return a formatted string with a name and url" do
      expect(host_name(Host.new(:name => 'name', :url => 'url'))).to eq('name (<span class="address">url</span>)')
    end
  end
end

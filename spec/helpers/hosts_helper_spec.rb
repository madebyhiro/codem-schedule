require 'spec_helper'

describe HostsHelper do
  context "name" do
    before(:each) do
      @host = Host.new(:address => '127.0.0.1')
    end
    
    it "should return the address without a name" do
      host_name(@host).should == '127.0.0.1'
    end
    
    it "should return the name plus address with a name" do
      @host.name = 'foo'
      host_name(@host).should == 'foo (<span class="address">127.0.0.1</span>)'
    end
  end
end

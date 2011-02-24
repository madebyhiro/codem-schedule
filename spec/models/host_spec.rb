require 'spec_helper'

describe Host do
  context "validations" do
    before(:each) do
      @valid_attributes = {
        :address => 'localhost'
      }
      @host = Host.new
    end
    
    it "should be valid with all valid attributes" do
      @host.attributes = @valid_attributes
      @host.should be_valid
    end
    
    it "should add http:// before the address if not present" do
      @host.attributes = @valid_attributes
      @host.save
      @host.address.should == 'http://localhost'
    end
    
    it "should strip the trailing / if present" do
      @host.attributes = @valid_attributes.merge(:address => 'localhost/')
      @host.save
      @host.address.should == 'http://localhost'
    end
  end
end

require 'spec_helper'

describe Host do
  describe "returning hosts with available slots" do
    before(:each) do
      @up   = double(Host, :update_status => true, :available_slots => 1)
      @down = double(Host, :update_status => true, :available_slots => 0)
      Host.stub!(:all).and_return [@up, @down]
    end
    
    def do_get
      Host.with_available_slots
    end
    
    it "should update the statuses" do
      @up.should_receive(:update_status)
      @down.should_receive(:update_status)
      do_get
    end
    
    it "should return the hosts with available slots" do
      do_get.should == [@up]
    end
  end
  
  describe "updating a host's status" do
    before(:each) do
      @host = Host.create!(:name => 'name', :url => 'url')
    end
    
    def update
      @host.update_status
    end
    
    describe "up" do
      before(:each) do
        Transcoder.stub!(:status).and_return({'max_slots' => 2, 'free_slots' => 1})
      end
      
      it "should be available" do
        update
        @host.should be_available
      end
      
      it "should have 2 max slots" do
        update
        @host.total_slots.should == 2
      end
      
      it "should have 1 free slots" do
        update
        @host.available_slots.should == 1
      end
    end
    
    describe "down" do
      before(:each) do
        Transcoder.stub!(:status).and_return false
      end
      
      it "should not be available" do
        update
        @host.should_not be_available
      end
    end
  end
end

require 'spec_helper'

describe Host do
  before(:each) do
    Transcoder.stub!(:host_status).and_return {}
  end
  
  describe "creating via the api" do
    def create_host
      Host.from_api('name' => 'name', 'url' => 'url')
    end
    
    it "should map the parameters" do
      create_host
      host = Host.last
      host.name.should == 'name'
      host.url.should == 'url'
    end
    
    it "should update the status" do
      host = mock("Host", :save => true)
      Host.stub!(:new).and_return host
      host.should_receive(:update_status)
      create_host
    end
    
    it "should return the host" do
      create_host.should == Host.last
    end
  end
  
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
      @host = Factory(:host)
    end
    
    def update
      @host.update_status
    end
    
    describe "up" do
      before(:each) do
        Transcoder.stub!(:host_status).and_return({'max_slots' => 2, 'free_slots' => 1})
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
      
      it "should return self" do
        update.should == @host
      end
    end
    
    describe "down" do
      before(:each) do
        Transcoder.stub!(:host_status).and_return false
      end
      
      it "should not be available" do
        update
        @host.should_not be_available
      end

      it "should return self" do
        update.should == @host
      end
    end
    
    it "should not update its status if the last update was < 10 seconds ago" do
      host = Factory(:host, :status_updated_at => 5.seconds.ago)
      host.should_not_receive(:save)
      host.update_status
    end
  end
end

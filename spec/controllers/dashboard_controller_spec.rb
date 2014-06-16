require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController, :type => :controller do
  describe "GET 'show'" do
    before(:each) do
      @jobs = double("Array of jobs")
      
      Job.stub_chain(:recents, :limit).and_return @jobs
      allow(@jobs).to receive(:scheduled).and_return 'scheduled'
      allow(@jobs).to receive(:processing).and_return [@job]
      allow(@jobs).to receive(:failed).and_return 'failed'
      
      allow(History).to receive(:new).and_return 'history'
    end
    
    def do_get
      get 'show', :period => 'period'
    end
    
    it "should assign the recently scheduled jobs" do
      do_get
      expect(assigns[:scheduled_jobs]).to eq('scheduled')
    end
    
    it "should assign the recently processing jobs" do
      do_get
      expect(assigns[:processing_jobs]).to eq([@job])
    end
    
    it "should assign the recently failed jobs" do
      do_get
      expect(assigns[:failed_jobs]).to eq('failed')
    end
    
    it "should generate a new history" do
      expect(History).to receive(:new).with('period')
      do_get
    end
    
    it "should assign the history for the view" do
      do_get
      expect(assigns[:history]).to eq('history')
    end
  end
end

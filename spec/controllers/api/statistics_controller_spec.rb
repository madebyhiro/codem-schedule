require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::StatisticsController, :type => :controller do
  describe "GET 'show'" do
    before(:each) do
      @history = double(History)
      allow(History).to receive(:new).and_return @history
    end
    
    def do_get
      get 'show', :period => 'period', format: 'json'
    end
    
    it "should generate a new history" do
      expect(History).to receive(:new).with('period')
      do_get
    end
  end
end

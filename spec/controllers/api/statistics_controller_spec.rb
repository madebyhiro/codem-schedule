require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::StatisticsController do
  describe "GET 'show'" do
    before(:each) do
      @history = double(History)
      History.stub(:new).and_return @history
    end
    
    def do_get
      get 'show', :period => 'period'
    end
    
    it "should generate a new history" do
      History.should_receive(:new).with('period')
      do_get
    end
  end
end

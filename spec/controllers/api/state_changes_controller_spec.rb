require 'spec_helper'

describe Api::StateChangesController do
  describe "GET 'index'" do
    before(:each) do
      @job = FactoryGirl.create(:job)
      @job.state_changes << StateChange.new(:state => 'state')
    end
    
    def do_get(format)
      get 'index', :id => @job.id, :format => format
    end
    
    it "shows state changes as json" do
      do_get(:json)
      response.body.should == @job.state_changes.to_json
    end

    it "shows state changes as xml" do
      do_get(:xml)
      response.body.should == @job.state_changes.to_xml
    end
  end
end

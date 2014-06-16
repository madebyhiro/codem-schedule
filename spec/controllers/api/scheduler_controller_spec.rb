require File.dirname(__FILE__) + '/../../spec_helper'

describe Api::SchedulerController, type: :controller do
  describe "GET 'schedule'" do
    before(:each) do
      @job = FactoryGirl.create(:job)
      allow(Schedule).to receive(:run!).and_return [@job]
    end

    def do_get
      get 'schedule', format: :json
    end

    it 'should let the runner schedule' do
      expect(Schedule).to receive(:run!)
      do_get
    end

    it 'should render the jobs' do
      do_get
      expect(response.body).to eq([@job].to_json)
    end
  end
end

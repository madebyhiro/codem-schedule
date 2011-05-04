require 'spec_helper'

describe Api::JobsController do
  describe "POST 'create'" do
    before(:each) do
      @job = double(Job, :save => true)
      Job.stub!(:from_api).and_return @job
    end

    def do_post
      post "create", :foo => 'bar'
    end
    
    it "should build a Job" do
      Job.should_receive(:from_api).with(hash_including(:foo => 'bar'))
      do_post
    end
    
    it "should save the job" do
      @job.should_receive(:save)
      do_post
    end
  end
end

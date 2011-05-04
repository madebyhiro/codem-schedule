require File.dirname(__FILE__) + '/../spec_helper'

describe Transcoder do
  context "scheduling a job" do
    before(:each) do
      @preset = Preset.create!(:name => 'h264', :parameters => 'params')
      @job    = Job.create!(:source_file => 'source', :destination_file => 'dest', :preset => @preset)
      @host   = Host.create!(:name => 'name', :url => 'url')

      JSON.stub!(:parse).and_return({'foo' => 'bar'})
    end

    def do_schedule
      Transcoder.schedule(:job => @job, :host => @host)
    end

    context "success" do
      before(:each) do
        Transcoder.stub!(:post).and_return mock("Response", :code => 202)
      end
      
      it "the job should enter transcoding" do
        @job.should_receive(:enter).with(Job::Transcoding, {'foo' => 'bar', 'host_id' => @host.id})
        do_schedule
      end
    end

    context "failed" do
      before(:each) do
        Transcoder.stub!(:post).and_return mock("Response", :code => 406)
      end

      it "should remain in scheduled state" do
        do_schedule
        @job.state.should == Job::Scheduled
      end
    end
  end
  
end

require 'spec_helper'

describe Api::JobsController do
  before(:each) do
    @preset = Preset.create!(:name => 'h264', :parameters => 'params')
  end

  describe "POST 'create'" do
    def do_post
      post "create", :input => 'input', :output => 'output', :preset => 'h264'
    end
    
    it "creates jobs" do
      do_post

      job = Job.last
      job.source_file.should == 'input'
      job.destination_file.should == 'output'
      job.preset.name.should == 'h264'
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @job = Job.create!(:source_file => 'input', :destination_file => 'output', :preset => @preset)
    end
    
    def do_get(format)
      get 'show', :id => @job.id, :format => format
    end
    
    it "shows a job as JSON" do
      do_get(:json)
      response.body.should == {:job => @job.attributes}.to_json
    end
    
    it "shows a job as XML" do
      do_get(:xml)
      response.body.should == @job.attributes.to_xml(:root => 'job')
    end
  end
end

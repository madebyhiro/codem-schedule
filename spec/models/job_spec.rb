require File.dirname(__FILE__) + '/../spec_helper'

describe Job do
  context "creating a Job via the api" do
    before(:each) do
      @h264 = Preset.create!(:name => 'h264')
    end
    
    it "should parse a basic call" do
      job = Job.from_api({
      	"input" => "input_file",
      	"output" => "output_file",
      	"preset" => "h264"
      })
      
      job.source_file.should == 'input_file'
      job.destination_file.should == 'output_file'
      job.preset.should == @h264
    end
    
  end
end


require 'spec_helper'

describe JobsHelper do
  describe "progress as percentage" do
    it "should be correct" do
      progress_as_percentage(0.4597).should == '45.97'
    end
  end
  
  it "should return the correct new job link" do
    new_job_link.should == link_to('New job', new_job_path)
  end
end

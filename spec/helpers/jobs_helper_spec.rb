require 'spec_helper'

include JobsHelper

describe JobsHelper do
  it "should return the correct new job link" do
    new_job_link.should == link_to('Create a new job', new_job_path)
  end
end

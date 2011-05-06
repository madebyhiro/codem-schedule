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
  
  it "should return the correct encoding time" do
    job = double(Job, :completed_at => 10, :transcoding_started_at => '5')
    encoding_time(job).should == 5
  end
  
  it "should return the correct filesize of the destination file" do
    File.should_receive(:size).with('foo').and_return 2_000
    job = double(Job, :destination_file => 'foo')
    destination_filesize(job).should == 2_000
  end
end

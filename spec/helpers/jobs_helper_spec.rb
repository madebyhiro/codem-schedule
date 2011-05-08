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
  
  it "should return 0 for any weird encoding times" do
    job = double(Job, :completed_at => nil, :transcoding_started_at => 1)
    encoding_time(job).should == 0
  end
  
  describe "destination filesize" do
    before(:each) do
      @job = double(Job, :destination_file => 'foo')
    end
    
    def filesize
      destination_filesize(@job)
    end
    
    it "should return the correct filesize" do
      File.should_receive(:size).with('foo').and_return 2_000
      filesize.should == 2_000
    end
    
    it "should handle missing files correctly" do
      File.stub!(:size).and_raise Errno::ENOENT
      filesize.should == 'unknown (file gone)'
    end
  end
  
  
  describe "notification dates" do
    before(:each) do
      job  = double(Job, :completed_at => 10)
      @not = double(Notification, :notified_at => 20, :job => job)
    end
    
    def notify
      notified_at @not
    end
    
    it "should return the correct number" do
      notify.should == '00:00:10'
    end
    
    it "should handle not sent notifications" do
      @not.stub!(:notified_at).and_return nil
      notify.should == nil
    end
  end
end

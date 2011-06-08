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
      @job = double(Job, :completed_at => 10)
      @not = double(Notification, :notified_at => 20)
    end
    
    def notify
      notified_at @not, @job
    end
    
    it "should return the correct number" do
      notify.should == '00:00:10'
    end
    
    it "should handle not sent notifications" do
      @not.stub!(:notified_at).and_return nil
      notify.should == nil
    end
  end
  
  it "should return the correct compression rate" do
    stub!(:destination_filesize).and_return 1_000
    job = double(Job, :filesize => 2_000)
    compression_rate(job).should == '50.00'
  end
  
  describe "number to time" do
    it "should return nil if seconds < 1" do
      number_to_time(0.5).should == nil
    end
    
    it "should return the correct string" do
      number_to_time(13_762).should == '03:49:22'
    end
    
    it "should be correct for times > 1 day" do
      number_to_time(95_099).should == '01:02:24:59'
    end
  end
end

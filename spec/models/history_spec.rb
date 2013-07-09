require File.dirname(__FILE__) + '/../spec_helper'

describe History do
  before(:each) do
    @now = Time.new(2011, 01, 02)
    Time.stub(:current).and_return @now
    @history = History.new
  end
  
  it "should set the default period to today" do
    History.new.period.should == 'today'
  end
  
  it "should allow setting of the period" do
    History.new('foo').period.should == 'foo'
  end
  
  it "should return the correct jobs" do
    @history.stub(:between).and_return 'between'
    Job.should_receive(:where).with(:created_at => 'between')
    @history.jobs
  end
  
  it "should convert 'today' to the correct period" do
    History.new('today').between.should == Range.new(@now.at_beginning_of_day, @now)
  end
  
  it "should convert 'yesterday' to the correct period" do
    History.new('yesterday').between.should == Range.new(@now - 1.day, @now)
  end
  
  it "should convert 'week' to the correct period" do
    History.new('week').between.should == Range.new(7.days.ago, @now)
  end
  
  it "should convert 'month' to the correct period" do
    History.new('month').between.should == Range.new(30.days.ago, @now)
  end
  
  it "should convert 'all' to the correct period" do
    History.new('all').between.should == Range.new(Time.new(1970,1,1), @now)
  end
  
  describe "scopes" do
    before(:each) do
      @jobs = double("Scope of jobs")
      @history.stub(:jobs).and_return @jobs
    end
    
    it "should return the completed jobs" do
      @jobs.should_receive(:where).with(:state => Job::Success).and_return 'c'
      @history.completed_jobs.should == 'c'
    end
    
    it "should return the number of completed jobs" do
      @history.stub(:completed_jobs).and_return [1,2,3]
      @history.number_of_completed_jobs.should == 3
    end
    
    it "should return the failed jobs" do
      Job.stub_chain(:where, :where).and_return @jobs
      @history.failed_jobs.should == @jobs
    end
    
    it "should return the number of failed jobs" do
      @history.stub(:failed_jobs).and_return [1,2]
      @history.number_of_failed_jobs.should == 2
    end

    it "should return the processing jobs" do
      @jobs.should_receive(:where).with(:state => Job::Processing).and_return 'p'
      @history.processing_jobs.should == 'p'
    end
    
    it "should return the number of processing jobs" do
      @history.stub(:processing_jobs).and_return [1]
      @history.number_of_processing_jobs.should == 1
    end
  end
  
  it "should return the correct number of seconds encoded" do
    @history.stub(:completed_jobs).and_return [double(Job, :duration => 10), double(Job, :duration => 2)]
    @history.seconds_encoded.should == 12
    
    @history.stub(:completed_jobs).and_return []
    @history.seconds_encoded.should == 0
  end
  
  it "should return the correct average processing time" do
    @history.stub(:completed_jobs).and_return [double(Job, :completed_at => 20, :transcoding_started_at => 10), 
                                                double(Job, :completed_at => 10, :transcoding_started_at => 5)]
    @history.average_processing_time.should == 7
    
    @history.stub(:completed_jobs).and_return []
    @history.average_processing_time.should == 0
  end

  it "should return the correct average queue time" do
    @history.stub(:completed_jobs).and_return [double(Job, :created_at => 10, :transcoding_started_at => 20), 
                                                double(Job, :created_at => 10, :transcoding_started_at => 30)]
    @history.average_queue_time.should == 15
    
    @history.stub(:completed_jobs).and_return []
    @history.average_queue_time.should == 0
  end
  
  describe "serialization" do
    before(:each) do
      @history = History.new
      @history.stub(
        :number_of_processing_jobs => 'p',
        :number_of_failed_jobs => 'f',
        :number_of_completed_jobs => 'c',
        :seconds_encoded => 'se',
        :average_processing_time => 'ap',
        :average_queue_time => 'aq'
      )
    end
    
    it "should serialize to json correctly" do
      @history.to_json.should == "{\"seconds_encoded\":\"se\",\"average_processing_time\":\"ap\",\"average_queue_time\":\"aq\",\"number_of_completed_jobs\":\"c\",\"number_of_failed_jobs\":\"f\",\"number_of_processing_jobs\":\"p\"}"
    end
    
    it "should serialize to xml correctly" do
      @history.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<statistics>\n  <seconds-encoded>se</seconds-encoded>\n  <average-processing-time>ap</average-processing-time>\n  <average-queue-time>aq</average-queue-time>\n  <number-of-completed-jobs>c</number-of-completed-jobs>\n  <number-of-failed-jobs>f</number-of-failed-jobs>\n  <number-of-processing-jobs>p</number-of-processing-jobs>\n</statistics>\n"
    end
  end
end

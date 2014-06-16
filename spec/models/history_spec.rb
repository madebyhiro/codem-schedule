require File.dirname(__FILE__) + '/../spec_helper'

describe History, :type => :model do
  before(:each) do
    @now = Time.new(2011, 01, 02)
    allow(Time).to receive(:current).and_return @now
    @history = History.new
  end
  
  it "should set the default period to today" do
    expect(History.new.period).to eq('today')
  end
  
  it "should allow setting of the period" do
    expect(History.new('foo').period).to eq('foo')
  end
  
  it "should return the correct jobs" do
    allow(@history).to receive(:between).and_return 'between'
    expect(Job).to receive(:where).with(:created_at => 'between')
    @history.jobs
  end
  
  it "should convert 'today' to the correct period" do
    expect(History.new('today').between).to eq(Range.new(@now.at_beginning_of_day, @now))
  end
  
  it "should convert 'yesterday' to the correct period" do
    expect(History.new('yesterday').between).to eq(Range.new(@now - 1.day, @now))
  end
  
  it "should convert 'week' to the correct period" do
    expect(History.new('week').between).to eq(Range.new(7.days.ago, @now))
  end
  
  it "should convert 'month' to the correct period" do
    expect(History.new('month').between).to eq(Range.new(30.days.ago, @now))
  end
  
  it "should convert 'all' to the correct period" do
    expect(History.new('all').between).to eq(Range.new(Time.new(1970,1,1), @now))
  end
  
  describe "scopes" do
    before(:each) do
      @jobs = double("Scope of jobs")
      allow(@history).to receive(:jobs).and_return @jobs
    end
    
    it "should return the completed jobs" do
      expect(@jobs).to receive(:where).with(:state => Job::Success).and_return 'c'
      expect(@history.completed_jobs).to eq('c')
    end
    
    it "should return the number of completed jobs" do
      allow(@history).to receive(:completed_jobs).and_return [1,2,3]
      expect(@history.number_of_completed_jobs).to eq(3)
    end
    
    it "should return the failed jobs" do
      allow(Job).to receive(:where).and_return @jobs
      allow(@jobs).to receive(:where).and_return @jobs
      expect(@history.failed_jobs).to eq(@jobs)
    end
    
    it "should return the number of failed jobs" do
      allow(@history).to receive(:failed_jobs).and_return [1,2]
      expect(@history.number_of_failed_jobs).to eq(2)
    end

    it "should return the processing jobs" do
      expect(@jobs).to receive(:where).with(:state => Job::Processing).and_return 'p'
      expect(@history.processing_jobs).to eq('p')
    end
    
    it "should return the number of processing jobs" do
      allow(@history).to receive(:processing_jobs).and_return [1]
      expect(@history.number_of_processing_jobs).to eq(1)
    end
  end
  
  it "should return the correct number of seconds encoded" do
    allow(@history).to receive(:completed_jobs).and_return [double(Job, :duration => 10), double(Job, :duration => 2)]
    expect(@history.seconds_encoded).to eq(12)
    
    allow(@history).to receive(:completed_jobs).and_return []
    expect(@history.seconds_encoded).to eq(0)
  end
  
  it "should return the correct average processing time" do
    allow(@history).to receive(:completed_jobs).and_return [double(Job, :completed_at => 20, :transcoding_started_at => 10), 
                                                double(Job, :completed_at => 10, :transcoding_started_at => 5)]
    expect(@history.average_processing_time).to eq(7)
    
    allow(@history).to receive(:completed_jobs).and_return []
    expect(@history.average_processing_time).to eq(0)
  end

  it "should return the correct average queue time" do
    allow(@history).to receive(:completed_jobs).and_return [double(Job, :created_at => 10, :transcoding_started_at => 20), 
                                                double(Job, :created_at => 10, :transcoding_started_at => 30)]
    expect(@history.average_queue_time).to eq(15)
    
    allow(@history).to receive(:completed_jobs).and_return []
    expect(@history.average_queue_time).to eq(0)
  end
  
  describe "serialization" do
    before(:each) do
      @history = History.new
      allow(@history).to receive(:number_of_processing_jobs).and_return 'p'
      allow(@history).to receive(:number_of_failed_jobs).and_return 'f'
      allow(@history).to receive(:number_of_completed_jobs).and_return 'c'
      allow(@history).to receive(:seconds_encoded).and_return 'se'
      allow(@history).to receive(:average_processing_time).and_return 'ap'
      allow(@history).to receive(:average_queue_time).and_return 'aq'
    end
    
    it "should serialize to json correctly" do
      expect(@history.to_json).to eq("{\"seconds_encoded\":\"se\",\"average_processing_time\":\"ap\",\"average_queue_time\":\"aq\",\"number_of_completed_jobs\":\"c\",\"number_of_failed_jobs\":\"f\",\"number_of_processing_jobs\":\"p\"}")
    end
    
    it "should serialize to xml correctly" do
      expect(@history.to_xml).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<statistics>\n  <seconds-encoded>se</seconds-encoded>\n  <average-processing-time>ap</average-processing-time>\n  <average-queue-time>aq</average-queue-time>\n  <number-of-completed-jobs>c</number-of-completed-jobs>\n  <number-of-failed-jobs>f</number-of-failed-jobs>\n  <number-of-processing-jobs>p</number-of-processing-jobs>\n</statistics>\n")
    end
  end
end

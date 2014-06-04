require 'spec_helper'

describe Job do
  describe "generating a job via the API" do
    before(:each) do
      @preset = FactoryGirl.create(:preset)
    end

    describe "successfull save" do
      before(:each) do
        @job = Job.from_api(
          { 
            "input" => "input", 
            "output" => "output", 
            "priority" => 1,
            "preset" => @preset.name, 
            "arguments" => "a=b,c=d"
          }, 
        )
      end
      
      it "should map the attributes correctly" do
        @job.source_file.should == 'input'
        @job.destination_file.should == 'output'
        @job.preset.should == @preset
        @job.priority.should == 1
        @job.arguments.should == { :a => 'b', :c => 'd' }
      end
      
      it "should be saved" do
        @job.should_not be_new_record
      end
    
      it "should be in the scheduled state" do
        @job.state.should == Job::Scheduled
      end
    end
    
    describe "failed save" do
      before(:each) do
        @job = Job.from_api({})
      end
      
      it "should not be saved" do
        @job.should be_new_record
      end
    end
  end

  describe "finished" do
    it "should be finished if Success" do
      Job.new(:state => Job::Success).should be_finished
    end

    it "should be finished if Failed" do
      Job.new(:state => Job::Failed).should be_finished
    end
  end
  
  describe "unfinished" do
    it "should be unfinished if Scheduled" do
      Job.new(:state => Job::Scheduled).should be_unfinished
    end

    it "should be unfinished if Processing" do
      Job.new(:state => Job::Processing).should be_unfinished
    end

    it "should be unfinished if Processing" do
      Job.new(:state => Job::OnHold).should be_unfinished
    end
  end
  
  describe "needs update" do
    it "should need an update if Processing" do
      Job.new(:state => Job::Processing).should be_needs_update
    end
    
    it "should need an update if OnHold" do
      Job.new(:state => Job::OnHold).should be_needs_update
    end
  end
  
  describe "getting the recent jobs" do
    before do
      @scope = double("Scope")
      @scope.stub(:recent).and_return @scope
      @scope.stub(:order).and_return @scope
      @scope.stub(:page).and_return @scope

      Job.stub(:all).and_return @scope
      Job.stub(:search).and_return @scope
    end

    it "should accept a query" do
      Job.should_receive(:search).with('q')
      Job.recents(query: 'q')
    end

    it "should accept an order and direction" do
      @scope.should_receive(:order).with('jobs.foo bar')
      Job.recents(sort: 'foo', dir: 'bar')
    end
  end

  describe 'deleting a job' do
    subject { FactoryGirl.create(:job) }

    it 'should delete the job from the transcoder' do
      Transcoder.should_receive(:remove_job).with(subject)
      subject.destroy
    end

    it 'should always return true' do
      subject.send(:remove_job_from_transcoder).should == true
    end
  end
end

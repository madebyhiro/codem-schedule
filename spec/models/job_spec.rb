require 'spec_helper'

describe Job, :type => :model do
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
        expect(@job.source_file).to eq('input')
        expect(@job.destination_file).to eq('output')
        expect(@job.preset).to eq(@preset)
        expect(@job.priority).to eq(1)
        expect(@job.arguments).to eq({ :a => 'b', :c => 'd' })
      end
      
      it "should be saved" do
        expect(@job).not_to be_new_record
      end
    
      it "should be in the scheduled state" do
        expect(@job.state).to eq(Job::Scheduled)
      end
    end
    
    describe "failed save" do
      before(:each) do
        @job = Job.from_api({})
      end
      
      it "should not be saved" do
        expect(@job).to be_new_record
      end
    end
  end

  describe "finished" do
    it "should be finished if Success" do
      expect(Job.new(:state => Job::Success)).to be_finished
    end

    it "should be finished if Failed" do
      expect(Job.new(:state => Job::Failed)).to be_finished
    end
  end
  
  describe "unfinished" do
    it "should be unfinished if Scheduled" do
      expect(Job.new(:state => Job::Scheduled)).to be_unfinished
    end

    it "should be unfinished if Processing" do
      expect(Job.new(:state => Job::Processing)).to be_unfinished
    end

    it "should be unfinished if Processing" do
      expect(Job.new(:state => Job::OnHold)).to be_unfinished
    end
  end
  
  describe "needs update" do
    it "should need an update if Processing" do
      expect(Job.new(:state => Job::Processing)).to be_needs_update
    end
    
    it "should need an update if OnHold" do
      expect(Job.new(:state => Job::OnHold)).to be_needs_update
    end
  end
  
  describe "getting the recent jobs" do
    before do
      @scope = double("Scope")
      allow(@scope).to receive(:recent).and_return @scope
      allow(@scope).to receive(:order).and_return @scope
      allow(@scope).to receive(:page).and_return @scope

      allow(Job).to receive(:all).and_return @scope
      allow(Job).to receive(:search).and_return @scope
    end

    it "should accept a query" do
      expect(Job).to receive(:search).with('q')
      Job.recents(query: 'q')
    end

    it "should accept an order and direction" do
      expect(@scope).to receive(:order).with('jobs.foo bar')
      Job.recents(sort: 'foo', dir: 'bar')
    end
  end

  describe 'deleting a job' do
    subject { FactoryGirl.create(:job) }

    it 'should delete the job from the transcoder' do
      expect(Transcoder).to receive(:remove_job).with(subject)
      subject.destroy
    end

    it 'should always return true' do
      expect(subject.send(:remove_job_from_transcoder)).to eq(true)
    end
  end
end

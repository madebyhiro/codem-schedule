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
            "preset" => @preset.name, 
            "arguments" => "a=b,c=d"
          }, 
          :callback_url => lambda { |job| "callback_#{job.id}" }
        )
      end
      
      it "should map the attributes correctly" do
        @job.source_file.should == 'input'
        @job.destination_file.should == 'output'
        @job.preset.should == @preset
        @job.callback_url.should == "callback_#{@job.id}"
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
        @job = Job.from_api({}, {})
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

    it "should be unfinished if Accepted" do
      Job.new(:state => Job::Accepted).should be_unfinished
    end

    it "should be unfinished if Processing" do
      Job.new(:state => Job::Processing).should be_unfinished
    end

    it "should be unfinished if Processing" do
      Job.new(:state => Job::OnHold).should be_unfinished
    end
  end
  
  describe "needs update" do
    it "should need an update if Accepted" do
      Job.new(:state => Job::Accepted).should be_needs_update
    end

    it "should need an update if Processing" do
      Job.new(:state => Job::Processing).should be_needs_update
    end
    
    it "should need an update if OnHold" do
      Job.new(:state => Job::OnHold).should be_needs_update
    end
  end
  
  describe "getting the recent jobs" do
    before(:each) do
      @job = double(Job)
      Job.stub_chain(:recent, :page).and_return [@job]
    end
    
    def recents
      Job.recents
    end
    
    it "should fetch the recent jobs" do
      Job.should_receive(:recent)
      recents
    end
    
    it "should return the jobs" do
      recents.should == [@job]
    end
  end

  describe "searching" do
    before(:each) do
      @scope = Job.scoped
      @scope.stub(:where).and_return @scope
      Job.stub(:scoped).and_return @scope
    end

    def search(str)
      Job.search(str)
    end

    it "should find a job by id" do
      @scope.should_receive(:where).with('jobs.id = ?', '1')
      search('id:1')
    end

    it "should find a job by state" do
      @scope.should_receive(:where).with('state = ?', 'failed')
      search('state:failed')
    end

    it "should find a job by source" do
      @scope.should_receive(:where).with('source_file LIKE ?', '%foo%')
      search('source:foo')
    end

    it "should find a job by input" do
      @scope.should_receive(:where).with('source_file LIKE ?', '%foo%')
      search('input:foo')
    end

    it "should find a job by dest" do
      @scope.should_receive(:where).with('destination_file LIKE ?', '%foo%')
      search('dest:foo')
    end

    it "should find a job by output" do
      @scope.should_receive(:where).with('destination_file LIKE ?', '%foo%')
      search('output:foo')
    end

    it "should find a job by file" do
      @scope.should_receive(:where).with('source_file LIKE ? OR destination_file LIKE ?', '%foo%', '%foo%')
      search('file:foo')
    end

    it "should find a job by preset" do
      @scope.should_receive(:where).with('presets.name LIKE ?', '%foo%')
      search('preset:foo')
    end

    it "should find a job by host" do
      @scope.should_receive(:where).with('hosts.name LIKE ?', '%foo%')
      search('host:foo')
    end

    it "should find a job by submitted" do
      t0 = 2.days.ago.at_beginning_of_day
      t1 = t0 + 1.day
      @scope.should_receive(:where).with('jobs.created_at BETWEEN ? AND ?', t0, t1)
      search('submitted:2_days_ago')
    end

    it "should find a job by completed" do
      t0 = 2.days.ago.at_beginning_of_day
      t1 = t0 + 1.day
      @scope.should_receive(:where).with('jobs.completed_at BETWEEN ? AND ?', t0, t1)
      search('completed:2_days_ago')
    end

    it "should find a job by started" do
      t0 = 2.days.ago.at_beginning_of_day
      t1 = t0 + 1.day
      @scope.should_receive(:where).with('jobs.transcoding_started_at BETWEEN ? AND ?', t0, t1)
      search('started:2_days_ago')
    end

    it "all together now!" do
      t0 = 2.days.ago.at_beginning_of_day
      t1 = t0 + 1.day

      @scope.should_receive(:where).with('jobs.id = ?', '1')
      @scope.should_receive(:where).with('state = ?', 'failed')
      @scope.should_receive(:where).with('source_file LIKE ?', '%foo%')
      @scope.should_receive(:where).with('destination_file LIKE ?', '%foo%')
      @scope.should_receive(:where).with('source_file LIKE ? OR destination_file LIKE ?', '%foo%', '%foo%')
      @scope.should_receive(:where).with('presets.name LIKE ?', '%foo%')
      @scope.should_receive(:where).with('hosts.name LIKE ?', '%foo%')
      @scope.should_receive(:where).with('jobs.created_at BETWEEN ? AND ?', t0, t1)
      @scope.should_receive(:where).with('jobs.completed_at BETWEEN ? AND ?', t0, t1)
      @scope.should_receive(:where).with('jobs.transcoding_started_at BETWEEN ? AND ?', t0, t1)

      search('id:1 state:failed source:foo dest:foo file:foo preset:foo host:foo created:2_days_ago completed:2_days_ago started:2_days_ago')
    end
  end

  describe "locking/unlocking" do
    before(:each) do
      @preset = Preset.create!(:name => 'n', :parameters => 'p')

      @job = Job.from_api(
        { 
          "input" => "input", 
          "output" => "output", 
          "preset" => @preset.name, 
          "arguments" => "a=b,c=d"
        }, 
        :callback_url => lambda { |job| "callback_#{job.id}" }
      )
    end

    it "should lock a job" do
      @job.lock!
      @job.should be_locked
    end

    it "should unlock a job" do
      @job.lock!
      @job.unlock!
      @job.should_not be_locked
    end

    it "should allow a block" do
      @job.lock! do
        @job.update_attributes :arguments => 'block_test'
      end
      @job.arguments.should == 'block_test'
      @job.should_not be_locked
    end

    it "should unlock a job if an error occurs in the block" do
      begin
        @job.lock! do
          raise 'foo'
        end
      rescue => e
      end

      @job.should_not be_locked
    end
  end
end

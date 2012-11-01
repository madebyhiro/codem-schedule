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
            "arguments" => "a=b,c=d",
            "additional" => " -v 100k"
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
        @job.additional_params.should == ' -v 100k'
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
    
    def recents(opts={})
      Job.recents(opts)
    end
    
    it "should fetch the recent jobs" do
      Job.should_receive(:recents)
      recents
    end

    it "should search the jobs if a query was given" do
      Job.should_receive(:search).with('q').and_return Job.scoped
      recents(:query => 'q').should == [@job]
    end
   
    it "should sort the jobs if :sort and :dir are given" do
      scoped_mock = double(Array)
      Job.stub_chain(:recent, :page).and_return scoped_mock
      scoped_mock.should_receive(:order).with('jobs.foo bar').and_return 'sorted'
      recents(:sort => 'foo', :dir => 'bar').should == 'sorted'
    end

    it "should return the jobs" do
      recents.should == [@job]
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

  describe "preset parameters" do
    before(:each) do
      @preset = Preset.new(:parameters => 'foo=bar')
      @job    = Job.new(:preset => @preset)
    end

    it "should work without additional params" do
      @job.preset_parameters.should == 'foo=bar'
    end

    it "should work with additional params" do
      @job.additional_params = 'abc=def'
      @job.preset_parameters.should == 'foo=bar abc=def'
    end
  end
end

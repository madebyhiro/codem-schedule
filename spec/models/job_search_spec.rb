require 'spec_helper'

describe JobSearch do
  before(:each) do
    @scope = Job.scoped
    @scope.stub!(:where).and_return @scope
    Job.stub!(:scoped).and_return @scope
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

  it "should not bork on an incorrect date" do
    lambda { search('started:banana_phone') }.should_not raise_error
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

require 'spec_helper'

describe JobSearch do
  pending

#  def search(str)
#    Job.search(str)
#  end
#
#  it "should find a job by id" do
#    job = FactoryGirl.create(:job)
#    another = FactoryGirl.create(:job)
#    search("id:#{job.id}").should == [ job ]
#  end
#
#  it "should find a job by state" do
#    job = FactoryGirl.create(:job, state: Job::Failed)
#    another = FactoryGirl.create(:job, state: Job::Scheduled)
#    search('state:failed').should == [ job ]
#  end
#
#  it "should find a job by source" do
#    job = FactoryGirl.create(:job, source_file: 'foo')
#    another = FactoryGirl.create(:job, source_file: 'bar')
#    search('source:foo').should == [ job ]
#  end
#
#  it "should find a job by input" do
#    job = FactoryGirl.create(:job, source_file: 'foo')
#    another = FactoryGirl.create(:job, source_file: 'bar')
#    search('input:foo').should == [ job ]
#  end
#
#  it "should find a job by dest" do
#    job = FactoryGirl.create(:job, destination_file: 'foo')
#    another = FactoryGirl.create(:job, destination_file: 'bar')
#    @scope.should_receive(:where).with('destination_file LIKE ?', '%foo%')
#    search('dest:foo').should == [ job ]
#  end
#
#  it "should find a job by output" do
#    job = FactoryGirl.create(:job, destination_file: 'foo')
#    another = FactoryGirl.create(:job, destination_file: 'bar')
#    @scope.should_receive(:where).with('destination_file LIKE ?', '%foo%')
#    search('output:foo').should == [ job ]
#  end
#
#  it "should find a job by file" do
#    j1 = FactoryGirl.create(:job, source_file: 'foo')
#    j2 = FactoryGirl.create(:job, destination_file: 'foo')
#    j3 = FactoryGirl.create(:job, destination_file: 'bar')
#    search('file:foo').should == [ j1, j2 ]
#  end
#
#  it "should find a job by preset" do
#    j1 = FactoryGirl.create(:job, preset: FactoryGirl.create(:preset, name: 'foo'))
#    j2 = FactoryGirl.create(:job, preset: FactoryGirl.create(:preset, name: 'bar'))
#    search('preset:foo').should == [ j1 ]
#  end
#
#  it "should find a job by host" do
#    found = FactoryGirl.create(:job, host: FactoryGirl.create(:host, name: 'foo'))
#    not_found = FactoryGirl.create(:job, host: FactoryGirl.create(:host, name: 'bar'))
#    search('host:foo').should == [ found ]
#  end
#
#  it "should find a job by submitted" do
#    t0 = 2.days.ago.at_beginning_of_day
#    t1 = t0 + 1.day
#    @scope.should_receive(:where).with('jobs.created_at BETWEEN ? AND ?', t0, t1)
#    search('submitted:2_days_ago')
#  end
#
#  it "should find a job by completed" do
#    t0 = 2.days.ago.at_beginning_of_day
#    t1 = t0 + 1.day
#    @scope.should_receive(:where).with('jobs.completed_at BETWEEN ? AND ?', t0, t1)
#    search('completed:2_days_ago')
#  end
#
#  it "should find a job by started" do
#    t0 = 2.days.ago.at_beginning_of_day
#    t1 = t0 + 1.day
#    @scope.should_receive(:where).with('jobs.transcoding_started_at BETWEEN ? AND ?', t0, t1)
#    search('started:2_days_ago')
#  end
#
#  it "should work with an invalid date" do
#    @scope.should_not_receive(:where)
#    search('started:foo_bar_baz')
#  end
#
#  it "all together now!" do
#    t0 = 2.days.ago.at_beginning_of_day
#    t1 = t0 + 1.day
#
#    @scope.should_receive(:where).with('jobs.id = ?', '1')
#    @scope.should_receive(:where).with('state = ?', 'failed')
#    @scope.should_receive(:where).with('source_file LIKE ?', '%foo%')
#    @scope.should_receive(:where).with('destination_file LIKE ?', '%foo%')
#    @scope.should_receive(:where).with('source_file LIKE ? OR destination_file LIKE ?', '%foo%', '%foo%')
#    @scope.should_receive(:where).with('presets.name LIKE ?', '%foo%')
#    @scope.should_receive(:where).with('hosts.name LIKE ?', '%foo%')
#    @scope.should_receive(:where).with('jobs.created_at BETWEEN ? AND ?', t0, t1)
#    @scope.should_receive(:where).with('jobs.completed_at BETWEEN ? AND ?', t0, t1)
#    @scope.should_receive(:where).with('jobs.transcoding_started_at BETWEEN ? AND ?', t0, t1)
#
#    search('id:1 state:failed source:foo dest:foo file:foo preset:foo host:foo created:2_days_ago completed:2_days_ago started:2_days_ago')
#  end
end


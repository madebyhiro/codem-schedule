require File.dirname(__FILE__) + '/../../spec_helper'

describe Jobs::ScheduleJob do
  before(:each) do
    @subject = Job.create!(:source_file => 'source', :destination_file => 'dest', :preset_id => 1)
    @job     = Jobs::ScheduleJob.new(@subject)
    @host    = Host.create!(:name => 'name', :url => 'url')
  end
end

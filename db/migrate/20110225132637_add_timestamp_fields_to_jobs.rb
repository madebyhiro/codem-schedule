class AddTimestampFieldsToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :transcoding_started_at, :datetime
    add_column :jobs, :completed_at, :datetime
  end

  def self.down
    remove_column :jobs, :transcoding_started_at
    remove_column :jobs, :completed_at
  end
end

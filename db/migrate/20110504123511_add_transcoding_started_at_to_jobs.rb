class AddTranscodingStartedAtToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :transcoding_started_at, :datetime
  end

  def self.down
    remove_column :jobs, :transcoding_started_at
  end
end

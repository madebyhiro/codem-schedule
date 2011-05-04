class AddRemoteJobIdToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :remote_job_id, :string
  end

  def self.down
    remove_column :jobs, :remote_job_id
  end
end

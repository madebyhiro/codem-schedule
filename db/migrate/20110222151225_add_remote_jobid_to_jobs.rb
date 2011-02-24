class AddRemoteJobidToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :remote_jobid, :string
  end

  def self.down
    remove_column :jobs, :remote_jobid
  end
end

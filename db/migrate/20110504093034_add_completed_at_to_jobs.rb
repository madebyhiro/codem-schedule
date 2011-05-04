class AddCompletedAtToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :completed_at, :datetime
  end

  def self.down
    remove_column :jobs, :completed_at
  end
end

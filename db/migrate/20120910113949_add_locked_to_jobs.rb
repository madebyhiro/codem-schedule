class AddLockedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :locked, :boolean, :default => false
  end
end

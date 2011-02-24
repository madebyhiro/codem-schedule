class UpdateStiOnJobs < ActiveRecord::Migration
  def self.up
    remove_column :jobs, :type
    add_column :jobs, :state, :string, :limit => 25, :null => false, :default => 'scheduled'
  end

  def self.down
    remove_column :jobs, :state
    add_column :jobs, :type, :string
  end
end

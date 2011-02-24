class AddPresetIdToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :preset_id, :integer, :null => false
  end

  def self.down
    remove_column :jobs, :preset_id
  end
end

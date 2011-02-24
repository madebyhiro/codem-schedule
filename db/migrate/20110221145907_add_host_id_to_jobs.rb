class AddHostIdToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :host_id, :integer
    add_index :jobs, :host_id
  end

  def self.down
    remove_column :jobs, :host_id
  end
end

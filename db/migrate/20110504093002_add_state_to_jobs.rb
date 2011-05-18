class AddStateToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :state, :string
    add_index :jobs, :state
  end

  def self.down
    remove_column :jobs, :state
  end
end

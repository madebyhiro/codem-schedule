class AddArgumentsToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :arguments, :text
  end

  def self.down
    remove_column :jobs, :arguments
  end
end

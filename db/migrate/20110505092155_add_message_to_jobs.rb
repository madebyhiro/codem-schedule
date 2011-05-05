class AddMessageToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :message, :string
  end

  def self.down
    remove_column :jobs, :message
  end
end

class AddLastStatusMessageToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :last_status_message, :string
  end

  def self.down
    remove_column :jobs, :last_status_message
  end
end

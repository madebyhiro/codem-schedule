class AddDestinationFileToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :destination_file, :string, :null => false
  end

  def self.down
    remove_column :jobs, :destination_file
  end
end

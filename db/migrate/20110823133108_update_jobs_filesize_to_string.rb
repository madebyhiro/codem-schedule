class UpdateJobsFilesizeToString < ActiveRecord::Migration
  def self.up
    change_column :jobs, :filesize, :string
  end

  def self.down
    change_column :jobs, :filesize, :integer
  end
end

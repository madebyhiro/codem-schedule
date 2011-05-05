class AddFileAttributesToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :progress, :float
    add_column :jobs, :duration, :integer
    add_column :jobs, :filesize, :integer
  end

  def self.down
    remove_column :jobs, :progress
    remove_column :jobs, :duration
    remove_column :jobs, :filesize
  end
end

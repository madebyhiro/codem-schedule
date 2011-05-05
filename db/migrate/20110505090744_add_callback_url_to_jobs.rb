class AddCallbackUrlToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :callback_url, :string
  end

  def self.down
    remove_column :jobs, :callback_url
  end
end

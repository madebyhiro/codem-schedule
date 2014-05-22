class RemoveCallbackUrlFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :callback_url
  end

  def down
    add_column :jobs, :callback_url, :string
  end
end

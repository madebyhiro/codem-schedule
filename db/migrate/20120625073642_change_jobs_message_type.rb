class ChangeJobsMessageType < ActiveRecord::Migration
  def up
    change_column :jobs, :message, :text, :limit => 65536
  end

  def down
    change_column :jobs, :message, :string
  end
end

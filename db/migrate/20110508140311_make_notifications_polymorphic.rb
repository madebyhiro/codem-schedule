class MakeNotificationsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :notifications, :job_id, :origin_id
    add_column :notifications, :origin_type, :string
    add_index :notifications, [:origin_id, :origin_type]
    Notification.connection.execute("UPDATE notifications SET origin_type = 'Job'")
  end

  def self.down
    rename_column :notifications, :origin_id, :job_id
    remove_column :notifications, :origin_type
    remove_index :notifications, [:origin_id, :origin_type]
  end
end

class AddNotifiedAtToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :notified_at, :datetime
  end

  def self.down
    remove_column :notifications, :notified_at
  end
end

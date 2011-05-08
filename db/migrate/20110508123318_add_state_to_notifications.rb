class AddStateToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :state, :string
  end

  def self.down
    remove_column :notifications, :state
  end
end

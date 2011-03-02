class AddMessageToStateChanges < ActiveRecord::Migration
  def self.up
    add_column :state_changes, :message, :string
  end

  def self.down
    remove_column :state_changes, :message
  end
end

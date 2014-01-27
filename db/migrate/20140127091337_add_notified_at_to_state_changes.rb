class AddNotifiedAtToStateChanges < ActiveRecord::Migration
  def change
    add_column :state_changes, :notified_at, :double
    add_index :state_changes, :notified_at
  end
end

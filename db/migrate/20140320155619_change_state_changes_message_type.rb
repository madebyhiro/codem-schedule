class ChangeStateChangesMessageType < ActiveRecord::Migration
  def up
    change_column :state_changes, :message, :text, :limit => 65536
  end

  def down
    change_column :state_changes, :message, :string
  end
end

class AddPositionToStateChanges < ActiveRecord::Migration
  def change
    add_column :state_changes, :position, :integer
    add_index :state_changes, :position
  end
end

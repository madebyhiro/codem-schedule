class AddStateChangeIdToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :state_change_id, :integer
    add_index :deliveries, :state_change_id
  end

  def self.down
    remove_column :deliveries, :state_change_id
  end
end

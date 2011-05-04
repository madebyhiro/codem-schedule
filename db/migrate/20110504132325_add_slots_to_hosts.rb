class AddSlotsToHosts < ActiveRecord::Migration
  def self.up
    add_column :hosts, :total_slots, :integer, :default => 0
    add_column :hosts, :available_slots, :integer, :default => 0
  end

  def self.down
    remove_column :hosts, :total_slots
    remove_column :hosts, :available_slots
  end
end

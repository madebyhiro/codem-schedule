class AddAvailableToHosts < ActiveRecord::Migration
  def self.up
    add_column :hosts, :available, :boolean, :default => false
  end

  def self.down
    remove_column :hosts, :available
  end
end

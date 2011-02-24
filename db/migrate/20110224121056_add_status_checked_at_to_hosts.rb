class AddStatusCheckedAtToHosts < ActiveRecord::Migration
  def self.up
    add_column :hosts, :status_checked_at, :datetime
  end

  def self.down
    remove_column :hosts, :status_checked_at
  end
end

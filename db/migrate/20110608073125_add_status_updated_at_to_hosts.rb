class AddStatusUpdatedAtToHosts < ActiveRecord::Migration
  def self.up
    add_column :hosts, :status_updated_at, :datetime
  end

  def self.down
    remove_column :hosts, :status_updated_at
  end
end

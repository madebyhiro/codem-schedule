class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.integer :notification_id, :null => false
      t.string :state, :null => false
      t.datetime :notified_at, :null => false

      t.timestamps
    end
    add_index :deliveries, :notification_id
  end

  def self.down
    drop_table :deliveries
  end
end

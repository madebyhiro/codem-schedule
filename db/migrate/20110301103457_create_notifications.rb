class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :preset_id
      t.string :kind
      t.string :value
      t.datetime :sent_at
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end

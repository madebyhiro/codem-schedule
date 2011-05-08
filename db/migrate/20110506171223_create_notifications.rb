class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :job_id
      t.string :type
      t.string :value

      t.timestamps
    end
    add_index :notifications, :job_id
  end

  def self.down
    drop_table :notifications
  end
end

class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :source_file, :null => false
      t.string :destination_file, :null => false
      t.integer :preset_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end

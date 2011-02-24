class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :source_file, :null => false
      t.string :duration
      t.integer :filesize
      t.string :progress, :limit => 6, :default => '0'
      t.string :type, :limit => 25

      t.timestamps
    end
    
    add_index :jobs, :type
  end

  def self.down
    drop_table :jobs
  end
end

class CreateHosts < ActiveRecord::Migration
  def self.up
    create_table :hosts do |t|
      t.string :name, :null => false, :unique => true
      t.string :url, :null => false, :unique => true

      t.timestamps
    end
  end

  def self.down
    drop_table :hosts
  end
end

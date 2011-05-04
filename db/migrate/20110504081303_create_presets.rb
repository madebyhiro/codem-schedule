class CreatePresets < ActiveRecord::Migration
  def self.up
    create_table :presets do |t|
      t.string :name, :null => false, :uniq => true

      t.timestamps
    end
    add_index :presets, :name
  end

  def self.down
    drop_table :presets
  end
end

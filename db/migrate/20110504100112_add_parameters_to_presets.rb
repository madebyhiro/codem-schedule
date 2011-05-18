class AddParametersToPresets < ActiveRecord::Migration
  def self.up
    add_column :presets, :parameters, :text
  end

  def self.down
    remove_column :presets, :parameters
  end
end

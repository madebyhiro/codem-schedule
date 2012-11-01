class AddWeightToPresets < ActiveRecord::Migration
  def change
    add_column :presets, :weight, :integer, limit: 2
  end
end

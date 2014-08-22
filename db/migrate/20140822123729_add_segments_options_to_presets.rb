class AddSegmentsOptionsToPresets < ActiveRecord::Migration
  def change
    add_column :presets, :segments_options, :text
  end
end

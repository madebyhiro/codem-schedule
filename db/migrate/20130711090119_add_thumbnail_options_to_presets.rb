class AddThumbnailOptionsToPresets < ActiveRecord::Migration
  def change
    add_column :presets, :thumbnail_options, :text
  end
end

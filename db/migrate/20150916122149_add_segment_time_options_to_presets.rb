class AddSegmentTimeOptionsToPresets < ActiveRecord::Migration
  def change
    add_column :presets, :segment_time_options, :string
  end
end

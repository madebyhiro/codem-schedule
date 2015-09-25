class AddSegmentTimeOptionsToPresets < ActiveRecord::Migration
  def change
    return if ActiveRecord::Base.connection.column_exists?(:presets, :segment_time_options)
    add_column :presets, :segment_time_options, :string
  end
end

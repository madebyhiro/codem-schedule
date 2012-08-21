class AddSearchIndexes < ActiveRecord::Migration
  def change
    add_index :jobs,    :source_file
    add_index :jobs,    :created_at
    add_index :jobs,    :completed_at
    add_index :jobs,    :transcoding_started_at

    add_index :hosts,   :name
    add_index :presets, :name
  end
end

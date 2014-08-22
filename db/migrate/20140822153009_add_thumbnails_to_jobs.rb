class AddThumbnailsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :thumbnails, :text
  end
end

class AddSegmentsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :playlist, :string
    add_column :jobs, :segments, :text
  end
end

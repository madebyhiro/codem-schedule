class AddPriorityToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :priority, :integer, limit: 3
  end
end

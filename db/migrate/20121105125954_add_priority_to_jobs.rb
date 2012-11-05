class AddPriorityToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :priority, :integer, default: 0
    add_index  :jobs, :priority
  end
end

class AddAdditionalParamsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :additional_params, :string

  end
end

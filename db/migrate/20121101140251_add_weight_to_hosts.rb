class AddWeightToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :weight, :integer, limit: 2
  end
end

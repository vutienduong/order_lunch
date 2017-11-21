class AddComponentableToDish < ActiveRecord::Migration
  def change
    add_column :dishes, :componentable, :boolean
  end
end

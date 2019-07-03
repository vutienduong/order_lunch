class AddComponentableToDish < ActiveRecord::Migration[4.2]
  def change
    add_column :dishes, :componentable, :boolean
  end
end

class RemoveRestaurantFromMenus < ActiveRecord::Migration[4.2]
  def change
    remove_reference :menus, :restaurant, index: true, foreign_key: true
  end
end

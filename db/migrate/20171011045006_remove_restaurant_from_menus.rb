class RemoveRestaurantFromMenus < ActiveRecord::Migration
  def change
    remove_reference :menus, :restaurant, index: true, foreign_key: true
  end
end

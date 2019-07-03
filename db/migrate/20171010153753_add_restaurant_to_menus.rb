class AddRestaurantToMenus < ActiveRecord::Migration[4.2]
  def change
    add_reference :menus, :restaurant, index: true, foreign_key: true
  end
end

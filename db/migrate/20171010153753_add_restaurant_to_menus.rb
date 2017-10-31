class AddRestaurantToMenus < ActiveRecord::Migration
  def change
    add_reference :menus, :restaurant, index: true, foreign_key: true
  end
end

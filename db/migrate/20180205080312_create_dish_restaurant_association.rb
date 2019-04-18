class CreateDishRestaurantAssociation < ActiveRecord::Migration[4.2]
  def change
    create_table :dish_restaurant_associations do |t|
      t.integer :dish_id
      t.integer :restaurant_id
    end
  end
end

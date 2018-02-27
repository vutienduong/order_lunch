class CreateDishRestaurantAssociation < ActiveRecord::Migration
  def change
    create_table :dish_restaurant_associations do |t|
      t.integer :dish_id
      t.integer :restaurant_id
    end
  end
end

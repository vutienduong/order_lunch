class CreateMenuRestaurants < ActiveRecord::Migration
  def change
    create_table :menu_restaurants do |t|
      t.integer :menu_id
      t.integer :restaurant_id

      t.timestamps null: false
    end
  end
end

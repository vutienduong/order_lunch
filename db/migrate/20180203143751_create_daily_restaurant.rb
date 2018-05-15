class CreateDailyRestaurant < ActiveRecord::Migration
  def change
    create_table :daily_restaurants do |t|
      t.integer :restaurant_id
      t.integer :dish_id
      t.date :date

      t.timestamps null: false
    end
  end
end

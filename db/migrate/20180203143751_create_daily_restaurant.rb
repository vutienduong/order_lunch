class CreateDailyRestaurant < ActiveRecord::Migration[4.2]
  def up
    unless ActiveRecord::Base.connection.table_exists? 'daily_restaurants'
      create_table :daily_restaurants do |t|
        t.integer :restaurant_id
        t.integer :dish_id
        t.date :date

        t.timestamps null: false
      end
    end
  end

  def down
    drop_table :daily_restaurants
  end
end

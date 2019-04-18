class ChangeRestaurantDailyColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :provider_dish_mappings, :restaurant_daily_id, :daily_restaurant_id
  end
end

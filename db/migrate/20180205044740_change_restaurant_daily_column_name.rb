class ChangeRestaurantDailyColumnName < ActiveRecord::Migration
  def change
    rename_column :provider_dish_mappings, :restaurant_daily_id, :daily_restaurant_id
  end
end

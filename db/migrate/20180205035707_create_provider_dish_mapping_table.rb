class CreateProviderDishMappingTable < ActiveRecord::Migration
  def change
    create_table :provider_dish_mappings do |t|
      t.integer :restaurant_daily_id
      t.integer :dish_id
    end
  end
end

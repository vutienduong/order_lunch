class AddColumnIsProviderToRestaurant < ActiveRecord::Migration
  def change
    add_column :daily_restaurants, :is_provider, :integer
  end
end

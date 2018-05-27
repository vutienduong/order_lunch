class AddColumnIsProviderToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :is_provider, :integer
  end
end

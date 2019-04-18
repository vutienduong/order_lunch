class AddColumnIsProviderToRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :restaurants, :is_provider, :integer
  end
end

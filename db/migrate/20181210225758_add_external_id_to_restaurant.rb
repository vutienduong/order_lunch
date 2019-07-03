class AddExternalIdToRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :restaurants, :external_id, :string
  end
end

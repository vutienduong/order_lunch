class AddExternalIdToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :external_id, :string
  end
end

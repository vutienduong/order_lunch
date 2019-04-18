class AddDescriptionToRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :restaurants, :description, :text
  end
end

class AddImageToRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :restaurants, :image, :bytea
  end
end

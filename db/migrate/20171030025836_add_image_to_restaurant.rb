class AddImageToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :image, :blob
  end
end

class AddImageLogoToRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :restaurants, :image_logo, :string
  end
end

class AddImageLogoToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :image_logo, :string
  end
end

class RemoveImageLogoFromRestaurant2 < ActiveRecord::Migration
  def change
    remove_column :restaurants, :image_logo, :string
  end
end

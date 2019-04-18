class RemoveImageUrlFromDish < ActiveRecord::Migration[4.2]
  def change
    remove_column :dishes, :image_url, :string
  end
end

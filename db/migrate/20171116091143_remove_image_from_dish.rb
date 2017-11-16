class RemoveImageFromDish < ActiveRecord::Migration
  def change
    remove_column :restaurants, :image_url, :string
  end
end

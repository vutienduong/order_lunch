class AddImageUrlToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :image_url, :string
  end
end

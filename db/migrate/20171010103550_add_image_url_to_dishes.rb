class AddImageUrlToDishes < ActiveRecord::Migration[4.2]
  def change
    add_column :dishes, :image_url, :string
  end
end

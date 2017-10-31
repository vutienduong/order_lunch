class AddImageToDish < ActiveRecord::Migration
  def change
    add_column :dishes, :image, :blob
  end
end

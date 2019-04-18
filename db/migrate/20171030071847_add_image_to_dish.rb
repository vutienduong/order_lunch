class AddImageToDish < ActiveRecord::Migration[4.2]
  def change
    add_column :dishes, :image, :bytea
  end
end

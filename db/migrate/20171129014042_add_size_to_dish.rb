class AddSizeToDish < ActiveRecord::Migration[4.2]
  def change
    add_column :dishes, :size, :string
  end
end

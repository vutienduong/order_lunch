class AddSizeToDish < ActiveRecord::Migration
  def change
    add_column :dishes, :size, :string
  end
end

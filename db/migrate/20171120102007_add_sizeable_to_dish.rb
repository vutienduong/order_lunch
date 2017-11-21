class AddSizeableToDish < ActiveRecord::Migration
  def change
    add_column :dishes, :sizeable, :boolean
  end
end

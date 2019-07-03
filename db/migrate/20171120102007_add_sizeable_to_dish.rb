class AddSizeableToDish < ActiveRecord::Migration[4.2]
  def change
    add_column :dishes, :sizeable, :boolean
  end
end

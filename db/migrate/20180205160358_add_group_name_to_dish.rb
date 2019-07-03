class AddGroupNameToDish < ActiveRecord::Migration[4.2]
  def change
    add_column :dishes, :group_name, :text
  end
end

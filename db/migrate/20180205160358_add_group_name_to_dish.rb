class AddGroupNameToDish < ActiveRecord::Migration
  def change
    add_column :dishes, :group_name, :text
  end
end

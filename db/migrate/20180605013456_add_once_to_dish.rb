class AddOnceToDish < ActiveRecord::Migration
  def change
    add_column :dishes, :once, :integer
  end
end

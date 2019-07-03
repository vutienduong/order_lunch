class AddOnceToDish < ActiveRecord::Migration[4.2]
  def change
    add_column :dishes, :once, :integer
  end
end

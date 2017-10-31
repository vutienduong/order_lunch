class RemoveDishIdFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :dishes_id, :integer
  end
end

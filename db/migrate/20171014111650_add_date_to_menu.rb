class AddDateToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :date, :date
  end
end

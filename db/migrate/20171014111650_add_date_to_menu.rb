class AddDateToMenu < ActiveRecord::Migration[4.2]
  def change
    add_column :menus, :date, :date
  end
end

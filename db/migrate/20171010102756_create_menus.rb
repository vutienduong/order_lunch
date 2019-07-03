class CreateMenus < ActiveRecord::Migration[4.2]
  def change
    create_table :menus do |t|
      t.datetime :date

      t.timestamps null: false
    end
  end
end

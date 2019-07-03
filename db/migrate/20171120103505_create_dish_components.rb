class CreateDishComponents < ActiveRecord::Migration[4.2]
  def change
    create_table :dish_components do |t|
      t.string :name
      t.string :type
      t.references :dish, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

class CreateDishes < ActiveRecord::Migration[4.2]
  def change
    create_table :dishes do |t|
      t.references :restaurant, index: true, foreign_key: true
      t.string :name
      t.decimal :price
      t.text :description

      t.timestamps null: false
    end
  end
end

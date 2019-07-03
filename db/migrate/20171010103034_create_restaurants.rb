class CreateRestaurants < ActiveRecord::Migration[4.2]
  def change
    create_table :restaurants do |t|
      t.references :menu, index: true, foreign_key: true
      t.string :name
      t.text :address

      t.timestamps null: false
    end
  end
end

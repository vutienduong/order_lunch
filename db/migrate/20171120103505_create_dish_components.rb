class CreateDishComponents < ActiveRecord::Migration
  def change
    create_table :salad_components do |t|
      t.string :name
      t.string :type
      t.references :dish, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

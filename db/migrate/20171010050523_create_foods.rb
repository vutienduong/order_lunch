class CreateFoods < ActiveRecord::Migration[4.2]
  def change
    create_table :foods do |t|
      t.text :title
      t.text :description
      t.text :creator
      t.datetime :date

      t.timestamps null: false
    end
  end
end

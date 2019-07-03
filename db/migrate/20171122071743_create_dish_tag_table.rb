class CreateDishTagTable < ActiveRecord::Migration[4.2]
  def change
    create_table :dishes_tags do |t|
      t.integer :dish_id
      t.integer :tag_id
    end
  end
end

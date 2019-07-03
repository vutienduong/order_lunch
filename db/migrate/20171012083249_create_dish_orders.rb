class CreateDishOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :dish_orders do |t|
      t.integer :dish_id
      t.integer :order_id

      t.timestamps null: false
    end
  end
end

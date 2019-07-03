class CreateOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      # t.references :dishes, index: true, foreign_key: true
      # t.references :dishes, index: true
      t.datetime :date

      t.timestamps null: false
    end
  end
end

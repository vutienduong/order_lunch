class CreateSizedPrices < ActiveRecord::Migration[4.2]
  def change
    create_table :sized_prices do |t|
      t.string :size
      t.decimal :price
      t.references :dish, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

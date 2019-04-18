class AddTotalPriceToOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :total_price, :integer
  end
end

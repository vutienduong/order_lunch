class AddPhoneToRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :restaurants, :phone, :string
  end
end

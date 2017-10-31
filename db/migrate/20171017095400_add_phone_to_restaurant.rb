class AddPhoneToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :phone, :string
  end
end

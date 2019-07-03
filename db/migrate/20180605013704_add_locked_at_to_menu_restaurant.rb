class AddLockedAtToMenuRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :menu_restaurants, :locked_at, :datetime
  end
end

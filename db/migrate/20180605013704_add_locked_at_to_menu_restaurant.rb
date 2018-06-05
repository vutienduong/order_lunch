class AddLockedAtToMenuRestaurant < ActiveRecord::Migration
  def change
    add_column :menu_restaurants, :locked_at, :datetime
  end
end

class RemoveMenuFromRestaurants < ActiveRecord::Migration[4.2]
  def change
    remove_reference :restaurants, :menu, index: true, foreign_key: true
  end
end

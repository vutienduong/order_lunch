class AddRefLinkToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :ref_link, :string
  end
end
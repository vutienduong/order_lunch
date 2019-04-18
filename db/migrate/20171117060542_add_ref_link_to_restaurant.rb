class AddRefLinkToRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :restaurants, :ref_link, :string
  end
end

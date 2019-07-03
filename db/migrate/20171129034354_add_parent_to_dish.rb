class AddParentToDish < ActiveRecord::Migration[4.2]
  def change
    add_reference :dishes, :parent, index: true
  end
end

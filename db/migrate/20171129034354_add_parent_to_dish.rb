class AddParentToDish < ActiveRecord::Migration
  def change
    add_reference :dishes, :parent, index: true
  end
end
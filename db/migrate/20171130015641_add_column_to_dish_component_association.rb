class AddColumnToDishComponentAssociation < ActiveRecord::Migration[4.2]
  def change
    add_column :dish_component_associations, :dish_id, :integer
    add_column :dish_component_associations, :dished_component_id, :integer
  end
end

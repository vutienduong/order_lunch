class CreateDishComponentAssociations < ActiveRecord::Migration[4.2]
  def change
    create_table :dish_component_associations do |t|

      t.timestamps null: false
    end
  end
end

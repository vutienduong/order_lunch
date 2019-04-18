class AddCustomizableToOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :customizable, :boolean, default: false
  end
end

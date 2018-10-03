class AddCustomizableToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :customizable, :boolean, default: false
  end
end

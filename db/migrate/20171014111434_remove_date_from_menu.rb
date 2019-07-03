class RemoveDateFromMenu < ActiveRecord::Migration[4.2]
  def change
    remove_column :menus, :date, :datetime
  end
end

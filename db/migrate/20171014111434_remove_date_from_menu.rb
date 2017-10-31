class RemoveDateFromMenu < ActiveRecord::Migration
  def change
    remove_column :menus, :date, :datetime
  end
end

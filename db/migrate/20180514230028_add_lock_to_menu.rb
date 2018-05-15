class AddLockToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :is_lock, :integer
    add_column :menus, :locked_at, :datetime
  end
end

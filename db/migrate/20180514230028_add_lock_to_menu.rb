class AddLockToMenu < ActiveRecord::Migration[4.2]
  def change
    add_column :menus, :is_lock, :integer
    add_column :menus, :locked_at, :datetime
  end
end

class ChangeTypeOfDateOfMenus < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :menus do |t|
        dir.up   { t.change :date, :datetime }
        dir.down { t.change :date, :date }
      end
    end
  end
end

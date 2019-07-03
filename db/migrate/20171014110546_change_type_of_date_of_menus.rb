class ChangeTypeOfDateOfMenus < ActiveRecord::Migration[4.2]
  def change
    reversible do |dir|
      change_table :menus do |t|
        dir.up   { t.change :date, :datetime }
        dir.down { t.change :date, :date }
      end
    end
  end
end

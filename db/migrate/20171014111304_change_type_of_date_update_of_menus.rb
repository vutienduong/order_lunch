class ChangeTypeOfDateUpdateOfMenus < ActiveRecord::Migration[4.2]
  def change
    def change
      reversible do |dir|
        change_table :menus do |t|
          dir.up   { t.change :date, :date }
          dir.down { t.change :date, :datetime }
        end
      end
    end
  end
end

class ChangeTypeOfAdminOfUser < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :users do |t|
        dir.up   { t.change :admin, :integer }
        dir.down { t.change :admin, :boolean }
      end
    end
  end
end

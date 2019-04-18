class ChangeTypeOfAdminOfUser < ActiveRecord::Migration[4.2]
  def change
    reversible do |dir|
      change_table :users do |t|
        dir.up   { t.change :admin, "integer USING admin::integer" }
        dir.down { t.change :admin, :boolean }
      end
    end
  end
end

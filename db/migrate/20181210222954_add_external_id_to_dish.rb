class AddExternalIdToDish < ActiveRecord::Migration
  def change
    add_column :dishes, :external_id, :string
  end
end

class AddExternalIdToDish < ActiveRecord::Migration[4.2]
  def change
    add_column :dishes, :external_id, :string
  end
end

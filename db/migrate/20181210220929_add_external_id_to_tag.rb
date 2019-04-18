class AddExternalIdToTag < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :external_id, :string
  end
end

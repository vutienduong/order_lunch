class AddExternalIdToTag < ActiveRecord::Migration
  def change
    add_column :tags, :external_id, :string
  end
end

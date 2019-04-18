class ChangeTypeToCategory < ActiveRecord::Migration[4.2]
  def change
    rename_column :dished_components, :type, :category
  end
end

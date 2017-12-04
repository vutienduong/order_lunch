class ChangeTypeToCategory < ActiveRecord::Migration
  def change
    rename_column :dished_components, :type, :category
  end
end

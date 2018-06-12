class AddTagToDish < ActiveRecord::Migration
  def change
    add_reference :dishes, :tags, references: :tags, index: true
  end
end
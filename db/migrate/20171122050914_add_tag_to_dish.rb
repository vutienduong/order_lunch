class AddTagToDish < ActiveRecord::Migration[4.2]
  def change
    add_reference :dishes, :tags, references: :tags, index: true
  end
end

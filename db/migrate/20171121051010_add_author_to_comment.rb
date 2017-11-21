class AddAuthorToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :author, references: :users, index: true
    add_foreign_key :comments, :users, column: :author_id
  end
end

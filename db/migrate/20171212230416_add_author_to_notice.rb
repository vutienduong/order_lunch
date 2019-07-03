class AddAuthorToNotice < ActiveRecord::Migration[4.2]
  def change
    add_reference :notices, :author, references: :users, index: true
  end
end

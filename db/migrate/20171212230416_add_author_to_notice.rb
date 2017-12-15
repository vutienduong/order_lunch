class AddAuthorToNotice < ActiveRecord::Migration
  def change
    add_reference :notices, :author, references: :users, index: true
  end
end

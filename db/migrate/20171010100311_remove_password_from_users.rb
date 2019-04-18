class RemovePasswordFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :password, :string
  end
end

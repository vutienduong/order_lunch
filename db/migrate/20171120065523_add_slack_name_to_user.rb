class AddSlackNameToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :slack_name, :string
  end
end

class CreateTagTable < ActiveRecord::Migration[4.2]
  def change
    create_table :tags do |t|
      t.string :name
    end
  end
end

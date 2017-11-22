class CreateTagTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.references :dishes, index: true, foreign_key: true
    end
  end
end
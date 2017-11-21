class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text :content
      t.date :date

      t.timestamps null: false
    end
  end
end

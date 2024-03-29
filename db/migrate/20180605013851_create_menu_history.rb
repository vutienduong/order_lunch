class CreateMenuHistory < ActiveRecord::Migration
  def change
    create_table :menu_histories do |t|
      t.references :menu, index: true, foreign_key: true
      t.references :actor
      t.datetime :datetime
      t.text :content
    end
  end
end

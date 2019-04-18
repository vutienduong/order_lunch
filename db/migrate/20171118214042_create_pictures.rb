class CreatePictures < ActiveRecord::Migration[4.2]
  def change
    create_table :pictures do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

class CreateOlConfigTable < ActiveRecord::Migration
  def change
    create_table :ol_configs do |t|
      t.text :name
      t.text :value
      t.text :note
    end
  end
end

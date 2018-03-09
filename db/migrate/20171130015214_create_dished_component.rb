class CreateDishedComponent < ActiveRecord::Migration
  def change
    create_table :dished_components do |t|
      t.string :name
      t.string :type
    end
  end
end

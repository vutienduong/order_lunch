class PersonalSetting < ActiveRecord::Migration
  def change
    create_table :personal_settings do |t|
      t.references :user, index: true, foreign_key: true
      t.string :key
      t.string :value
    end
  end
end

class CreateGeneralSetting < ActiveRecord::Migration[4.2]
  def change
    create_table :general_settings do |t|
      t.string :key
      t.string :value
    end
  end
end

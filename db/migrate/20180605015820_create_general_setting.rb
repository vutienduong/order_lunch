class CreateGeneralSetting < ActiveRecord::Migration
  def change
    create_table :general_settings do |t|
      t.string :key
      t.string :value
    end
  end
end

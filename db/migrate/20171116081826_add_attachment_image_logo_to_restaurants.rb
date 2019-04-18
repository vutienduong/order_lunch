class AddAttachmentImageLogoToRestaurants < ActiveRecord::Migration[4.2]
  def self.up
    change_table :restaurants do |t|
      t.attachment :image_logo
    end
  end

  def self.down
    remove_attachment :restaurants, :image_logo
  end
end

class AddAttachmentImageLogoToDishes < ActiveRecord::Migration[4.2]
  def self.up
    change_table :dishes do |t|
      t.attachment :image_logo
    end
  end

  def self.down
    remove_attachment :dishes, :image_logo
  end
end

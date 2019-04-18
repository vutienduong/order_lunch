class AddImageLogoToRestaurant2 < ActiveRecord::Migration[4.2]
  def change
    def self.up
      add_attachment :restaurants, :image_logo
    end

    def self.down
      remove_attachment :restaurants, :image_logo
    end
  end
end

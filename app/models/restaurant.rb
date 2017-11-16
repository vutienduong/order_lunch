class Restaurant < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :menu_restaurants
  has_many :menus, through: :menu_restaurants
  has_many :dishes
  has_attached_file :image_logo, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end

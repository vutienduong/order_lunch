class Dish < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {scope: :restaurant, message: 'each restaurant doesn\'t have two dishes which are same named'}

  validates_numericality_of :price, greater_than_or_equal_to: 1000

  validates_presence_of :restaurant

  belongs_to :restaurant

  has_many :dish_orders
  has_many :orders, through: :dish_orders

  has_attached_file :image_logo, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image_logo, :content_type => /\Aimage\/.*\Z/
end

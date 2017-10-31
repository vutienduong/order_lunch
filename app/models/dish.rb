class Dish < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {scope: :restaurant, message: "each restaurant doesn't have two dishes which are same named"}

  belongs_to :restaurant

  has_many :dish_orders
  has_many :orders, through: :dish_orders
end

class Dish < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {scope: :restaurant, message: 'each restaurant doesn\'t have two dishes which are same named'}

  validates_numericality_of :price, greater_than_or_equal_to: 1000

  validates_presence_of :restaurant

  belongs_to :restaurant

  has_many :dish_orders
  has_many :orders, through: :dish_orders
end

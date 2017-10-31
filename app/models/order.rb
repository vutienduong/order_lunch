class Order < ActiveRecord::Base
  belongs_to :user
  has_many :dish_orders
  has_many :dishes, through: :dish_orders
end

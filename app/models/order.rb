class Order < ActiveRecord::Base
  validates :user, presence: true, uniqueness: {
    scope: :date, message: 'each user doesn\'t have two order which are same date'
  }
  validates :date, presence: true

  belongs_to :user
  has_many :dish_orders
  has_many :dishes, through: :dish_orders

  def cal_total_price
    dishes.inject(0) { |s, d| s += d.price }
  end
end

# frozen_string_literal: true

class Order < ActiveRecord::Base
  validates :user, presence: true, uniqueness: {
    scope: :date, message: 'each user doesn\'t have two order which are same date'
  }
  validates :date, presence: true

  belongs_to :user
  has_many :dish_orders
  has_many :dishes, through: :dish_orders

  MONTH_AVG_LIMIT = 80_000
  DF_CR_UNIT = 'VND'

  def cal_total_price
    dishes.sum(:price)
  end
end

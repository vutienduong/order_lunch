class ProviderDishMapping < ActiveRecord::Base
  validates :dish_id, presence: true, uniqueness: { scope: :daily_restaurant_id, message: 'each provider doesn\'t have duplicated dishes' }
  validates :daily_restaurant_id, presence: true
  belongs_to :daily_restaurant
  belongs_to :dish
end

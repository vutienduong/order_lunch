class DailyRestaurant < ActiveRecord::Base
  validates :date, presence: true
  validates :restaurant_id, presence: true
  has_many :restaurants
  has_many :dishes, through: :provider_dish_mappings
  has_many :provider_dish_mappings

  def dish_decorators
    show_dishes = dishes.compact
    variants = show_dishes.map &:variants
    variants.delete_if &:blank?
    variants.flatten!
    variants.each { |v| show_dishes.delete(v) }
    show_dishes
  end

  def restaurant
    Restaurant.find(restaurant_id)
  end
end

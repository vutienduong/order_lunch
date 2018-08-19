class Menu < ActiveRecord::Base
  validates :restaurants, presence: true
  validates :date, presence: true, uniqueness: true

  has_many :menu_restaurants
  has_many :menu_histories
  has_many :restaurants, through: :menu_restaurants
  accepts_nested_attributes_for :restaurants

  attr_accessor :provider_ids

  def lock!(time)
    update(is_lock: true, locked_at: time)
  end

  def open!
    update(is_lock: false)
  end

  def get_menu_restaurant_with(restaurant_id)
    menu_restaurants.find_by(restaurant_id: restaurant_id)
  end

  def available_restaurants(compared_time)
    @available_restaurants ||= restaurants.select do |restaurant|
      locked_at = get_menu_restaurant_with(restaurant.id)&.locked_at
      locked_at.blank? || locked_at >= compared_time
    end
  end
end

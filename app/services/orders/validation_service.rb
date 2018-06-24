class Orders::ValidationService
  def self.validate_add_dish?(compared_time, dish, menu)
    restaurant_locked_at = MenuRestaurant.find_by(
      restaurant_id: dish.restaurant.id, menu_id: menu.id
    )&.locked_at
    restaurant_locked_at.blank? || restaurant_locked_at > compared_time
  end
end

module SQLGenerator
  def self.test_generate
    'test generate'
  end

  def self.test_helper
    'this is helper'
  end

  def self.set_image_nil
    Restaurant.all.each do |r|
      r.update(image: nil)
    end

    Dish.all.each do |r|
      r.update(image: nil)
    end
  end

  def self.fix_price_to_number
    Dish.where(price: nil).each do |d|
      d.update(price: 20000.to_d)
    end

    Dish.where('price < ?', 1000.to_d).each {|o| o.update price: 20000.to_d}
  end

  def self.change_nil_restaurant_to_the_last
    last_r = Restaurant.last
    Dish.where(restaurant: nil).each do |d|
      d.update restaurant: last_r
    end
  end

  def self.change_all_orther_nil_to_the_last
    last_d = Dish.last
    last_o = Order.last
    DishOrder.where(order_id: nil).each {|o| o.update order_id: last_o.id}
    DishOrder.where(dish_id: nil).each {|o| o.update dish_id: last_d.id}
    MenuRestaurant.where(restaurant_id: nil).destroy_all
    MenuRestaurant.where(menu_id: nil).destroy_all
  end

  def self.fix_data
    SQLGenerator.set_image_nil
    SQLGenerator.fix_price_to_number
    SQLGenerator.change_nil_restaurant_to_the_last
    SQLGenerator.change_all_orther_nil_to_the_last
  end

  def self.retest_fix
    Restaurant.where(image: nil).length == Restaurant.count && \
      Dish.where(image: nil).length == Dish.count && \
      Dish.where(price: nil).empty? && \
      Dish.where(restaurant: nil).empty? && \
      DishOrder.where(order_id: nil).empty? && \
      DishOrder.where(dish_id: nil).empty? && \
      MenuRestaurant.where(restaurant_id: nil).empty? && \
      MenuRestaurant.where(menu_id: nil).empty?
  end

  def self.generate_sql
    sql = []
    [User, Restaurant, Dish, Menu, MenuRestaurant, Order, DishOrder].each do |table|
      table.all.each {|u| sql.push SQLGenerator.generate_for_record u}
    end
    sql
  end

  def self.generate_for_record record
    record.class.arel_table.create_insert.tap {|im|
      im.insert(record.send(
          :arel_attributes_with_values_for_create,
          record.attributes.compact.keys
      ))
    }.to_sql
  end
end
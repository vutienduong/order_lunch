RSpec.shared_context "shared stuff", :shared_context => :metadata do
  before {@some_var = :some_value}

  def shared_method
    "it works"
  end

  [User, Restaurant, Dish, DishOrder, Menu, MenuRestaurant, Order].each do |table|
    table.destroy_all
  end

  let! (:user_1) {create(:user)}
  let! (:user_2) {create(:user)}

  let! (:restaurant_1) {create(:restaurant)}
  let! (:restaurant_2) {create(:restaurant)}
  let! (:restaurant_3) {create(:restaurant)}

  let! (:dish_11) {create(:dish, restaurant: restaurant_1)}
  let! (:dish_12) {create(:dish, restaurant: restaurant_1)}
  let! (:dish_21) {create(:dish, restaurant: restaurant_2)}
  let! (:dish_22) {create(:dish, restaurant: restaurant_2)}

  let! (:menu) {create(:menu, date: Date.today, restaurants: [restaurant_1, restaurant_2, restaurant_3])}

  let! (:order_1) {create(:order, date: Date.today, user: user_1, dishes: [dish_11, dish_22])}
  let! (:order_2) {create(:order, date: Date.today, user: user_2, dishes: [dish_12, dish_21, dish_11])}

  subject do
    'this is the subject'
  end
end

RSpec.configure do |rspec|
  rspec.include_context "shared stuff", :include_shared => true
end
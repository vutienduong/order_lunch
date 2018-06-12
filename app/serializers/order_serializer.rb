class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :date, :note,
      :total_price, :dishes, :user_info

  def dishes
    object.dishes.map do |dish|
      DishSerializer.new(dish).attributes
    end
  end

  def total_price
    object.dishes.map(&:price).inject(0) { |s, e| s = s + e }
  end

  def user_info
    user = User.find(object.user_id)
    UserLightweightSerializer.new(user).attributes
  end
end

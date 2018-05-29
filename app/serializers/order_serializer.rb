class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :date, :note,
      :total_price, :dishes

  def dishes
    object.dishes.map do |dish|
      DishSerializer.new(dish).attributes
    end
  end

  def total_price
    object.dishes.map(&:price).inject(0) {|s, e| s=s+e}
  end
end

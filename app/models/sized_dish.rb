class SizedDish < Dish
  attr_accessor :size
  def initialize size
    @size = size
  end
end
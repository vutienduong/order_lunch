class SizedDish < Dish
  attr_accessor :size
  validates :size, presence: true, uniqueness: {scope: :name, message: 'dishes with same name have to have different size'}

  def display_name
    name.split(/\[[^\[]*\]/).last
  end

  def name
    "#{super} [#{size}]"
  end
end
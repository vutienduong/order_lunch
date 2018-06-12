class Provider < Restaurant
  has_many :daily_restaurants, foreign_key: 'restaurant_id'

  def test_res_method
    puts 'This is test Provider'
  end
end

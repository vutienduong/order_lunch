class DailyRestaurant::CreateMultiDishesService
  attr_accessor :names, :prices, :provider_id, :date

  BLANK_DATE_ERROR = 'Date is blank.'.freeze
  DIFF_LENGTH_ERROR = 'Number of dishes and @prices must be same!'.freeze

  def initialize(names, prices, provider_id, date)
    @names = names
    @prices = prices
    @provider_id = provider_id
    @date = date
  end

  def call
    @prices = ExtractLineService.split_line(@prices)
    @names = ExtractLineService.split_line(@names)

    return export_error(DIFF_LENGTH_ERROR) if @prices.length != names.length
    return export_error(BLANK_DATE_ERROR) if date.blank?

    @provider = Provider.find(@provider_id)
    parse_date = ParseDateService.parse_date(@date)
    @daily_restaurant = DailyRestaurant.find_by(restaurant_id: @provider.id, date: parse_date)

    if @daily_restaurant.blank?
      @daily_restaurant = DailyRestaurant.new(restaurant_id: @provider.id, date: parse_date)
      return export_error(create_daily_res_err(@provider.name, parse_date)) unless @daily_restaurant.save
      @daily_restaurant.reload
    end

    result = { success: [], fail: [] }
    data = ConvertDataService.two_array_to_hash(@names, @prices, ['name', 'price'])
    data.each do |d|
      dish = Dish.where(name: d['name'], price: d['price'], restaurant_id: @provider.id).first_or_create
      pdm = ProviderDishMapping.where(dish_id: dish.id, daily_restaurant_id: @daily_restaurant.id).first_or_create
      result[:success] << dish
    end
    return result
  end

  def export_error(err)
    { error: err }
  end

  def create_daily_res_err(name, date)
    "Can not create provider menu for restaurant: #{name} and date #{date}."
  end
end

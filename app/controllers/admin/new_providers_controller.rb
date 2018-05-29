class Admin::NewProvidersController < Admin::AdminsController
  BLANK_DATE_ERROR = 'Date is blank.'.freeze
  DIFF_LENGTH_ERROR = 'Number of dishes and prices must be same!'.freeze

  def add_dishes
    @message = 'Building ... will available soon'
  end

  def group_add_dishes
    @providers = Restaurant.providers
    respond_to do |format|
      format.js
      format.html do
        render 'group_add_dishes'
      end
    end
  end

  def post_group_add_dishes
    prices = params[:provider][:dish_prices]
    prices = ExtractLineService.split_line(prices)

    dish_names = params[:provider][:dish_names]
    dish_names = ExtractLineService.split_line(dish_names)

    if prices.length != dish_names.length
      @error = DIFF_LENGTH_ERROR
      return
    end

    date = params[:provider][:select_date]
    unless date.blank?
      @error = BLANK_DATE_ERROR
      return
    end

    @provider = Provider.find(params[:provider_id])
    parse_date = ParseDateService.parse_date(date)
    @daily_restaurant = DailyRestaurant.find_by(restaurant_id: @provider.id, date: parse_date)

    if @daily_restaurant.blank?
      @daily_restaurant = DailyRestaurant.new(restaurant_id: @provider.id, date: parse_date)
      unless @daily_restaurant.save
        @error = cannot_create_daily_res_err(@provider.name, parse_date)
        return
      end
      @daily_restaurant.reload
    end

    @result = { success: [], fail: [] }
    data = ConvertDataService.two_array_to_hash(dish_names, prices, ['name', 'price'])
    data.each do |d|
      dish = Dish.where(name: d['name'], price: d['price'], restaurant_id: @provider.id).first_or_create
      pdm = ProviderDishMapping.where(dish_id: dish.id, daily_restaurant_id: @daily_restaurant.id).first_or_create
      @result[:success] << dish
    end

    respond_to do |format|
      format.js do
        render 'post_group_add_dishes'
      end
    end
  end

  def get_dishes_of_date
    date = params[:date]
    if date.present?
      parse_date = ParseDateService.parse_date(date)
      @provider = Provider.find(params[:provider_id])
      @dishes = @provider.load_dishes(parse_date)

      if @dishes.nil?
        @no_daily_restaurant = true
      end
    else
      @error = BLANK_DATE_ERROR
    end

    respond_to do |format|
      format.js do
        render 'get_dishes_of_date'
      end
    end
  end

  private

  def cannot_create_daily_res_err(name, date)
    "Can not create provider menu for restaurant: #{name} and date #{date}."
  end
end

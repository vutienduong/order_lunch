class Admin::NewProvidersController < Admin::AdminsController
  BLANK_DATE_ERROR = 'Date is blank.'.freeze
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
    names = params[:provider][:dish_names]
    prices = params[:provider][:dish_prices]
    provider_id = params[:provider][:provider]
    date = params[:provider][:select_date]

    service = ::DailyRestaurant::CreateMultiDishesService.new(names, prices, provider_id, date)
    @result = service.call

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

      @no_daily_restaurant = true if @dishes.nil?
    else
      @error = BLANK_DATE_ERROR
    end

    respond_to do |format|
      format.js do
        render 'get_dishes_of_date'
      end
    end
  end
end

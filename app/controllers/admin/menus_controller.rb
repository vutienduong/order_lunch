class Admin::MenusController < Admin::AdminsController
  before_action :hide_provider, only: %i[new edit]
  def new
    @restaurants = Restaurant.all if params[:provider].blank?
    @providers = Restaurant.providers if params[:restaurant].blank?
    len = @restaurants.blank? ? @providers.length : @restaurants.length
    @display_size = len < 20 ? len : 20
    @menu = Menu.new
    @dummy = { dummy: nil }
    @date = params[:select_date]
  end

  def create
    _menu_params = menu_params
    selected_date = _menu_params[:date]
    provider_ids = _menu_params[:provider_ids].to_a
    _menu_params[:restaurant_ids] = [] if _menu_params[:restaurant_ids].blank?
    _menu_params[:restaurant_ids] = _menu_params[:restaurant_ids] + provider_ids
    _menu_params.delete(:provider_ids)

    @menu = Menu.new(_menu_params)
    raise MyError::CreateFailError, @menu.errors.messages unless @menu.save

    redirect_to menu_path(@menu)
    return # TODO: currently we temporarily do not support creating provider
    if provider_ids.blank?
      redirect_to menu_path(@menu)
    else
      # create DailyRestaurants
      provider_ids.each do |provider_id|
        DailyRestaurant.create(restaurant_id: provider_id, date: selected_date)
      end

      # redirect to select dishes page
      daily_restaurant_ids =
        DailyRestaurant.where('DATE(date)=?', selected_date)
        .pluck(:id)

      if daily_restaurant_ids.count == 1
        redirect_to admin_select_dish_for_provider_path(daily_restaurant_ids.first)
      else
        # TODO: refactor later, for case of more than one provider in a day
        redirect_to admin_select_dish_for_provider_path(daily_restaurant_ids.first)
      end
    end
  end

  def edit
    @menu = Menu.find(params[:id])
    @restaurants = Restaurant.all
    @providers = Restaurant.providers
    len = @restaurants.length
    @display_size = len < 20 ? len : 20
  end

  def update
    @menu = Menu.find(params[:id])
    raise MyError::UpdateFailError, @menu.errors.messages unless @menu.update(menu_params)
    redirect_to menu_path(@menu)
  end

  def request_menu; end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    redirect_to menus_path
  end

  def lock
    @menu = Menu.find(params[:id])
    @menu.lock!(Time.current)
    redirect_to menus_path
  end

  def open
    @menu = Menu.find(params[:id])
    @menu.open!
    redirect_to menus_path
  end

  def lock_option
    @options = convert_lock_option(params[:lock_options])
    respond_to do |format|
      format.js { render 'generate_lock_option' }
    end
  end

  def lock_restaurants
    @menu = Menu.find(params[:id])
  end

  def post_lock_restaurants
    # TODO : fix lock here
    lock_times = params[:lock_time]
    lock_times.each do |lock_time|
      if lock_time[1]["hidden"] == 'false'
        mr = MenuRestaurant.find_by(menu_id: params[:id], restaurant_id: lock_time[0])
        next if mr.blank?
        mr.update(locked_at: nil)
      else
        parse_lock_time = ParseDateService.convert_array_to_time(lock_time[1])
        mr = MenuRestaurant.find_by(menu_id: params[:id], restaurant_id: lock_time[0])
        next if mr.blank?
        mr.update(locked_at: parse_lock_time)
      end
    end
    redirect_to menu_path(params[:id])
  end

  private

  def menu_params
    params.require(:menu)
      .permit(:date, restaurant_ids: [], provider_ids: [])
  end

  def hide_provider
    @hide_provider = true
  end

  def convert_lock_option(options)
    convert_options = []
    options.each do |option|
      convert_options << {
        no: option[0],
        id: option[1][:id],
        name: option[1][:name]
      }
    end
    convert_options
  end
end

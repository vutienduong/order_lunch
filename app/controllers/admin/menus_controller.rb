class Admin::MenusController < Admin::AdminsController
  def new
    @restaurants = Restaurant.restaurants if params[:provider].blank?
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
    raise MyError::CreateFailError.new @menu.errors.messages unless @menu.save
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
        #TODO: refactor later, for case of more than one provider in a day
        redirect_to admin_select_dish_for_provider_path(daily_restaurant_ids.first)
      end
    end
  end

  def edit
    @menu = Menu.find(params[:id])
    @restaurants = Restaurant.all
    len = @restaurants.length
    @display_size = len < 20 ? len : 20
  end

  def update
    @menu = Menu.find(params[:id])
    raise MyError::UpdateFailError.new @menu.errors.messages unless @menu.update(menu_params)
    redirect_to menu_path(@menu)
  end

  def request_menu
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    redirect_to menus_path
  end

  private
  def menu_params
    params.require(:menu)
        .permit(:date, restaurant_ids: [], provider_ids: [])
  end
end

class Admin::ProvidersController < Admin::AdminsController
  SPLIT_PATTERN = "\r\n".freeze
  SUCCESS = 'Success'.freeze
  FAIL = 'Fail'.freeze

  NO_MENU_STT = 'no_menu_stt'
  CAN_NOT_SET_STT = 'can_not_set_stt'
  ALREADY_SET_STT = 'already_set_stt'
  PENDING_STT = 'pending_stt'
  REST_DATE_STT = 'rest_day_stt'
  NEED_TO_SET_PROVIDER_STT = 'need_provider_stt'

  NOTHING_TODO = 'nothing to do'
  SET_MENU_TODO = 'set menu first'
  SET_DISH_TODO = 'go set dish'

  WDAY_MAP = { '1' => 'Monday', '2' => 'Tuesday', '3' => 'Wednesday', '4' => 'Thursday', '5' => 'Friday' }

  DAY_NAMES = %w[Monday Tuesday Wednesday Thursday Friday]

  attr_accessor :select_date

  def destroy
    daily_restaurant_id = params[:id]
    daily_restaurant = DailyRestaurant.find(daily_restaurant_id)
    selected_date = daily_restaurant.date

    # delete on menu / or delete menu if empty restaurant after all
    menu = Menu.find_by(selected_date: selected_date)
    menu.restaurants.delete(Restaurant.find(daily_restaurant.restaurant_id))
    menu.destroy if menu.restaurants.blank?

    # delete on provider-dishes mapping
    ProviderDishMapping.where(daily_restaurant_id: daily_restaurant_id)

    # delete on daily restaurant
    daily_restaurant.destroy

    redirect_to root_path
  end

  def select_dish_for_provider
    @daily_restaurant = DailyRestaurant.find(params[:id])
    @restaurant = Restaurant.find(@daily_restaurant.restaurant_id)
    @dishes = @restaurant.dishes
  end

  def confirm_dish_for_provider
    dish_ids = params[:provider][:dish_ids]
    dish_ids.select! { |dish_id| dish_id }
    daily_restaurant_id = params[:provider][:daily_restaurant_id]
    dish_ids.each do |dish_id|
      ProviderDishMapping.create(daily_restaurant_id: daily_restaurant_id, dish_id: dish_id)
    end

    @dishes = DailyRestaurant.find(daily_restaurant_id).dishes
  end

  def confirm_add_dish_for_provider_daily
    dish_ids = params[:group_names]
    dish_ids.select! { |dish_id| dish_id }
    daily_restaurant_id = params[:provider][:daily_restaurant_id]
    dish_ids.each do |dish_id|
      ProviderDishMapping.create(daily_restaurant_id: daily_restaurant_id, dish_id: dish_id)
    end

    @dishes = DailyRestaurant.find(daily_restaurant_id).dishes
    redirect_to admin_set_month_menu_path
  end

  def quick_add_dishes
    @restaurants = Restaurant.all
  end

  def save_quick_add_dishes
    dish_names = params[:dishes][:dish_names].split(SPLIT_PATTERN)
    return if dish_names.blank?
    dish_names.uniq!

    @restaurant = Restaurant.find(params[:dishes][:restaurant_id])
    @create_dish_result = dish_names.map do |dish_name|
      dish = Dish.new(name: dish_name, price: 0, restaurant: @restaurant)
      { save: dish.save ? SUCCESS : FAIL, name: dish_name }
    end
  end

  def quick_add_with_type
    @restaurants = Restaurant.providers
  end

  def save_quick_add_with_type
    restaurant = Restaurant.find(params[:dishes][:restaurant_id])
    group_names = params[:dishes][:dish_types]
    list_dish_names = params[:dishes][:dish_names]
    results = []

    group_names.each_with_index { |group_name, index|
      dish_names = list_dish_names[index]
      next if dish_names.blank?
      dish_names = dish_names.split(SPLIT_PATTERN)
      temp_result = dish_names.map do |dish_name|
        dish = Dish.new(name: dish_name,
            price: 0,
            restaurant: restaurant,
            group_name: group_name
        )

        { save: dish.save ? SUCCESS : FAIL,
            name: dish_name,
            group: group_name }
      end

      results |= temp_result
      temp_result
    }

    @restaurant = restaurant
    @create_dish_result = results
  end

  def set_menu_for_month
    select_date_to_set
  end

  def select_date_to_set
    return if params[:date].blank? and params[:select_date].blank?
    date = if params[:date].blank?
             Date.parse(params[:select_date])
           else
             Date.parse(params[:date][:date])
           end
    @select_date = date
    @status = (date.at_beginning_of_month..date.at_end_of_month).map do |at_date|
      { date: at_date, status: get_set_dish_status(at_date) }
    end
    current_stt = get_set_dish_status(date)
    @to_do = case current_stt
               when REST_DATE_STT, CAN_NOT_SET_STT, ALREADY_SET_STT
                 NOTHING_TODO
               when NO_MENU_STT
                 SET_MENU_TODO
               else
                 SET_DISH_TODO
             end

    if current_stt == PENDING_STT
      @daily_restaurant = DailyRestaurant.where('Date(date) = ?', date).first
      @restaurant = @daily_restaurant.restaurant
      @dishes = @restaurant.dishes
      @group_names = @dishes.pluck(:group_name).uniq
      first_group = @group_names.first
      @first_dishes = @dishes.where(group_name: first_group)
    end

    @current_stt = current_stt
    render 'admin/providers/set_menu_for_month'
  end

  def add_provider_for_month
  end

  def post_add_provider_for_month
    if params[:provider][:step] == '1'
      add_provider_step_1
    elsif params[:provider][:step] == '2'
      add_provider_step_2
    else
      add_provider_step_3
    end
  end

  def add_provider_step_1
    year = params[:provider][:year]
    month = params[:date][:month]
    prefix = "Provider_#{year}_#{month}"
    result = { success: [], fail: [] }
    provider_names = []
    if (providers = Restaurant.where("name like '#{prefix}%'")).blank?
      day_names = WDAY_MAP.values
      day_names.each do |day_name|
        provider_name = "#{prefix}_#{day_name}"
        provider = Restaurant.new(name: provider_name, is_provider: true)
        provider.save ? result[:success] << provider_name : result[:fail] << provider_name
        provider_names << { name: provider_name, dishes: [] }
      end
      @result = result
      @provider_names = provider_names
    else
      @error = 'Providers have been existed for this month!'
      @provider_names = providers.map do |provider|
        { name: provider.name, dishes: provider.dishes.pluck(:name) }
      end
    end
    render 'add_provider_for_month_step_2'
  end

  def add_provider_step_2
    p_dishes_arr = params[:provider][:dishes]
    result = {}
    p_dishes_arr.each do |p_dishes|
      p_dishes = p_dishes.last
      provider = Restaurant.where(name: p_dishes[:name], is_provider: true)

      next if provider.blank?
      provider = provider.first
      temp_result = { success: [], fail: [] }
      dish_names = p_dishes[:dishes]
      dish_names = dish_names.split(SPLIT_PATTERN)
      dish_names.each do |dish_name|
        dish = Dish.new(name: dish_name, restaurant: provider, price: 0)
        dish.save ? temp_result[:success] << dish.name : temp_result[:fail] << dish.name
      end
      result[provider.name] = temp_result
    end
    @result = result
    render 'add_provider_for_month_step_3'
  end

  def add_provider_step_3
    render 'add_provider_for_month_finish'
  end

  def default_provider_menu_day
  end

  def post_default_provider_menu_day
    year = params[:provider][:year]
    month = params[:date][:month]
    prefix = "Provider_#{year}_#{month}"
    result = { success: [], fail: [] }
    if (restaurants = Restaurant.where("name like '#{prefix}%'")).blank?
      # create providers first
      @date = { month: month, year: year }
      render 'admin/providers/immediate_confirm_create_month_provider'
    else
      date = Date.strptime("#{year}/#{month}", '%Y/%m')
      # grant for each day

      mon_res = restaurants.find_by(name: "#{prefix}_Monday")
      tue_res = restaurants.find_by(name: "#{prefix}_Tuesday")
      wed_res = restaurants.find_by(name: "#{prefix}_Wednesday")
      thu_res = restaurants.find_by(name: "#{prefix}_Thursday")
      fri_res = restaurants.find_by(name: "#{prefix}_Friday")
      wday_res = [mon_res, tue_res, wed_res, thu_res, fri_res]

      (date.at_beginning_of_month..date.at_end_of_month).each do |at_date|
        if at_date.saturday? or at_date.sunday?
          next
        end
        idx = at_date.wday
        restaurant = wday_res[idx - 1]
        menu = Menu.new(date: at_date, restaurants: [restaurant])
        if menu.save
          result[:success] << at_date
          DailyRestaurant.create(restaurant_id: restaurant.id, date: at_date)
        else
          result[:fail] << at_date
        end
      end
      @month = "#{month}/#{year}"
      @result = result
      render 'result_default_provider_menu_day'
    end
  end

  private
  def get_menu_on(date)
    Menu.where('Date(date) = ?', date).first
  end

  def get_set_dish_status(date)
    return REST_DATE_STT if date.sunday? or date.saturday?
    return NO_MENU_STT if (menu = get_menu_on(date)).blank?
    providers = menu.restaurants.select { |r| r.is_provider? }
    return CAN_NOT_SET_STT if providers.blank?
    daily_restaurant = providers.first.provider_by_date(date)
    if daily_restaurant.blank?
      NEED_TO_SET_PROVIDER_STT
    elsif daily_restaurant.dishes.blank?
      PENDING_STT
    else
      ALREADY_SET_STT
    end
  end
end

class UsersController < ApplicationController
  include UsersHelper
  include SQLGenerator
  include UploadImageS3
  include UserPermissionUtility
  include ApplicationHelper
  before_action :require_login

  def admin?
    @user.admin
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    check_modified_user_permission params[:id]
    @user = retrieve_user params[:id]
  end

  def update
    check_modified_user_permission params[:id]
    @user = retrieve_user params[:id]
    raise MyError::UpdateFailError unless @user.update(user_params)
    redirect_to user_path(@user)
  end

  def select_dish
    @var1 = 'Var 1'
    redirect_to controller: 'restaurants', action: 'show_detail', id: params[:id], select_dish: 1
  end

  def order
    select_date = select_date_params[:select_date]
    select_date = select_date ? Date.parse(select_date) : Date.today

    @menu = Menu.where('DATE(date)=?', select_date).first
    @select_date = select_date

    return if @menu.blank?
    if select_date < Date.today ||
        (select_date == Date.today && @menu.is_lock? && Time.current > @menu.locked_at)
      @locked = true
      @locked_time = @menu.locked_at
      return
    end

    # render 'menus/request_menu'

    @today_order = Orders::RetrieveService.find_order_by_user_id_and_date session[:user_id], select_date

    # session[:today_order] = @today_order.blank? ? nil : @today_order
    # session[:today_order_id] = session[:today_order].blank? ? nil : session[:today_order]['id']

    # @dishes = []
    # @menu.restaurants.each {|r| @dishes.push(r.dishes)}
    # @dishes.flatten!
    # @tags = collect_follow_tags @dishes

    @r_tags = Menus::RetrieveService.new(@menu).collect_follow_tags_for_each_restaurant

    @total_price = @today_order.blank? ? 0 : @today_order.cal_total_price

    # all orders
    @all_orders = Order.where('DATE(date)=?', select_date)

    @available_restaurants = @menu.available_restaurants(Time.current)
    @avg_cost_on_month = AverageCostService.call(current_user.id)
    num_day_of_month = ParseDateService.weekdays_in_month_given_a_date(Date.current)
    @total_allow_budget_for_month = num_day_of_month * Order::MONTH_AVG_LIMIT
  end

  def collect_follow_tags(dishes)
    tags = {}
    dishes.group_by(&:tags).each do |tag, dish|
      name = tag.first
      tags[name] = [] unless tags[name]
      tags[name].push dish
    end
    tags
  end

  def get_all_orders_today
    @all_orders = Order.where('DATE(date)=?', Date.today)
    render 'get_all_orders_today'
  end

  def delete_today_order_session
    session[:today_order] = nil
    render plain: 'Delete today orders session'
  end

  def save_order
    add_dish_params
    if params[:dish][:action] == 'add'
      add_dish_to_order
    else
      remove_dish_from_order
    end
  end

  def add_dish_to_order
    user_id = session[:user_id]
    date = params[:select_date]
    dish_id = params[:dish][:dish_id]
    checked_time = Time.current

    service = OrderServices::AddDish.new(user_id, dish_id, date, checked_time)
    service.call

    msg = if service.success?
            { status: STATUS_OK, message: MSG_SUCCESS }
          else
            { status: STATUS_FAIL, message: service.errors }
          end

    msg[:today] = session[:today_order] if msg[:status] == STATUS_OK
    @order = service.order

    # guarantee that always response json
    response_to_json msg
  end

  def remove_dish_from_order
    date = params[:select_date]
    order = Orders::RetrieveService.find_order_by_user_id_and_date current_user.id, date
    if order.present?
      @order_dishes = DishOrder.where('order_id = ? AND dish_id = ?',
                                      order.id,
                                      params[:dish][:dish_id]).all
      @order_dishes.last.destroy if @order_dishes.length >= 1
      if order.dishes.blank?
        order.destroy
        order = nil
      end
    end

    # guarantee that always response json
    msg = { status: STATUS_OK, message: MSG_SUCCESS, today: order }
    response_to_json msg
  end

  def add_dish_to_order_no_ajax
    add_dish_to_order_params
    date = Date.today
    order = Orders::RetrieveService.find_order_by_user_id_and_date current_user.id, date
    if order_id.blank?
      order = Orders::RetrieveService.find_order_by_user_id_and_date(session[:user_id], date)
      order_id = order.id if order.present?
    end

    if order_id.blank?
      order = Order.new(user_id: session[:user_id], date: date, dish_ids: [params[:dish_id]])
      raise MyError::CreateFailError, 'Fail when try to create order' unless order.save
    else
      order = Order.find_by(id: order_id)
      raise MyError::NonExistRecordError, 'Order with this id is not exist' if order.blank?
      dish_ids = order.dishes.map(&:id).push(params[:dish_id])
      raise MyError::UpdateFailError, 'Fail when try to add new dish for order' unless order.update(dish_ids: dish_ids)
    end
    redirect_to order_user_path(current_user.id)
  end

  def add_dish
    redirect_to '/users/test'
  end

  def edit_note
    date = params[:select_date]
    order = Orders::RetrieveService.find_order_by_user_id_and_date current_user.id, date
    msg = {}
    msg[:status] = order.blank? ? STATUS_FAIL : (order.update(edit_note_params) ? STATUS_OK : STATUS_FAIL)

    respond_to do |format|
      format.json { render json: msg }
    end
  end

  def copy_order
    copy_info_params
    date = params[:copy_info][:select_date]
    flash[:error] = 'Copy function temporarily close.'
    redirect_to order_user_path(current_user, select_date: date)
    return

    order = Orders::RetrieveService.find_order_by_user_id_and_date current_user.id, date
    if order.blank?
      @order = Order.create user_id: current_user.id, date: date
      current_order_id = @order.id
    else
      current_order_id = order.id
      @dish_orders = DishOrder.where(order_id: current_order_id).all
      @dish_orders.each(&:destroy)
    end

    # add all copied dishes follow copied user
    if params[:copy_info][:dish_ids].present?
      params[:copy_info][:dish_ids].each do |d|
        @dish_order = DishOrder.new(order_id: current_order_id, dish_id: d)
        @dish_order.save
      end
    end

    # update note
    # @order = Order.find(current_order_id)
    @order.update_attributes(note: params[:copy_info][:note]) if @order.present?
    redirect_to order_user_path(current_user, select_date: date)
  end

  def copy_ajax
    @copy_available = if params[:copy_info][:dish_ids].present?
                        @menu = Menu.where('DATE(date)=?', params[:copy_info][:select_date]).first
                        available_for_copy? params[:copy_info][:dish_ids], @menu
                      else
                        []
                      end
  end

  def post_copy_ajax
    date = params[:copy_info][:select_date]
    @menu = Menu.where('DATE(date)=?', date).first
    available_dishes = available_for_copy? params[:copy_info][:dish_ids].split(" "), @menu
    @order = Orders::RetrieveService.find_order_by_user_id_and_date(current_user.id, date)

    if @order.blank?
      @order = Order.create user_id: current_user.id, date: date
      current_order_id = @order.id
    else
      current_order_id = @order.id
      DishOrder.where(order_id: current_order_id).destroy_all
    end

    # add all copied dishes follow copied user
    available_dishes.each do |d|
      if d.values.first.dig(:status, :valid)
        dish_id = d.keys.first
        dish_order = DishOrder.new(order_id: current_order_id, dish_id: dish_id)
        dish_order.save
      end
    end

    # update note
    @order.update_attributes(note: params[:copy_info][:note]) if @order.present?
    flash[:success] = I18n.t('order.copy.success')
    redirect_to order_user_path(current_user, select_date: date)
  end

  def change_password
    check_modified_user_permission params[:id]
    @user = User.find params[:id]
  end

  def confirm_change_password
    check_modified_user_permission params[:id]
    valid_params = change_pass_params
    @user = User.find params[:id]
    if @user.authenticate valid_params[:old_password]
      raise MyError::BlankNewPassword if valid_params[:password].blank?
      valid_params.except! :old_password
      @user.update valid_params
      redirect_to user_path @user
    else
      raise MyError::WrongOldPassword
    end
  end

  def test
    # @sql = SQLGenerator.generate_sql

    # UsersHelper.fix_data
    # @sql = UsersHelper.retest_fix ? 'fix done' : 'fix fail'
    # record = User.last
    # record = Dish.find_by id: 42
    # @sql = generate_sql record

    # @sql = ''
    # UploadImageS3.test_upload
  end

  def test_ajax
    users = User.where('email LIKE ? ', "%#{params[:keyword]}%").limit(10)
    respond_to do |format|
      format.json { render json: { status: STATUS_OK, users: users } }
    end
  end

  def get_dish; end

  def help
    render 'help'
  end

  def new_update
    render 'new_update'
  end

  private

  def add_dish_to_order_params
    params.permit(:dish_id)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :slack_name)
  end

  def add_dish_params
    params.require(:dish).permit(:user_id, :dish_id, :action, :order_id)
    params.permit(:select_date)
  end

  def edit_note_params
    params.require(:order).permit(:order_id, :note)
  end

  def copy_info_params
    params.require(:copy_info).permit(:dish_ids, :user_id, :order_id, :note, :select_date)
  end

  def query_date_string(date)
    "date LIKE '%#{date}%'"
  end

  def retrieve_user(id)
    user = User.find_by id: id
    raise MyError::NonExistRecordError unless user
    user
  end

  def change_pass_params
    params.require(:user).permit(:old_password, :password)
  end

  def select_date_params
    params.permit(:select_date)
  end

  def available_for_copy?(dish_ids, menu)
    dish_ids.map do |dish_id|
      dish = Dish.find_by(id: dish_id)
      if dish.nil?
        { dish_id.to_s => { error: I18n.t('not_found') } }
      else
        menu_res = menu.menu_restaurants.find_by(restaurant_id: dish.restaurant_id)
        if menu_res.locked_at.nil? || menu_res.locked_at >= Time.now.utc
          { dish_id.to_s => { status: { valid: true, msg: 'can order' },
                              info: { dish_name: dish.name } } }
        else
          { dish_id.to_s => { status: { valid: false,
                                        msg: "Restaurant #{dish.restaurant.name} has locked" },
                              info: { dish_name: dish.name } } }
        end
      end
    end
  end
end

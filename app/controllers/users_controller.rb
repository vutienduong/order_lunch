class UsersController < ApplicationController
  #before_action :logged_in_user

  def admin?
    @user.admin
  end

  def index
    @users = User.all
    #byebug
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    check_user_permission(params[:id].to_i)
    @user = User.find(params[:id])
  end

  def update
    check_user_permission(params[:id])
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      @error = ErrorCode::ERR_USER_EDIT_FAIL
      render 'layouts/error'
    end
  end

  def select_dish
    @var1 = "Var 1"
    redirect_to controller: 'restaurants', action: 'show_detail', id: params[:id], select_dish: 1
  end

  def order
    @menu = Menu.where('date BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).last
    get_order_today
    # dishes, total_price
    if @menu.nil?
      # if this is admin, redirect to "menus/new"
      render 'menus/request_menu'
    else
      @menu_includes = Menu.includes(restaurants: :dishes).find(@menu.id)
      @dishes = []
      @menu_includes.restaurants.each do |r|
        @dishes.push(r.dishes)
      end
      @dishes = @dishes.flatten
      @total_price = @today_order.nil? ? 0 : @today_order.dishes.inject(0) {|sum, e| sum + e.price}
    end

    # all orders
    @all_orders = Order.where("DATE(date)=?", Date.today)
  end

  def get_all_orders_today
    @all_orders = Order.where("DATE(date)=?", Date.today)
    render 'get_all_orders_today'
  end

  def get_order_today
    @today_order = Order.where('user_id= ? AND date BETWEEN ? AND ?', session[:user_id], DateTime.now.beginning_of_day, DateTime.now.end_of_day).first

    if @today_order.blank?
      @order = Order.new(user_id: session[:user_id], date: Date.today)
      if @order.save
        session[:today_order_id] = @order.id
        session[:today_order] = @order
      end
    else
      session[:today_order_id] = @today_order.id
      session[:today_order] = @today_order
    end
  end

  def delete_today_order_session
    session[:today_order] = nil
    render plain: 'Delete today orders session'
  end

  def add_dish_to_order(isAjax)
    msg = {:status => "fail"}

    @log={} # Note: relate to @log[] = ... later, can cause error without this initialize
    if session[:today_order].nil?
      #edit new orders for that day
      @order = Order.new(user_id: session[:user_id], date: Date.today)
      if @order.save
        @order.id = Order.last.id
        session[:today_order] = @order
        session[:today_order_id] = @order.id
        @log[:first] = "edit new orders success"
      end
    else
      # orders for that day already existed
      @order = session[:today_order]
    end

    # add dish for that orders
    @order_dish = DishOrder.new(order_id: session[:today_order_id], dish_id: params[:dish][:dish_id])

    if @order_dish.save
      @log[:second] = "Update orders-dish success" # Note: this line can cause error because of lacking of @log={}
      msg = {:status => "ok", :message => "Success!", :html => "<b>...</b>", today: session[:today_order]}
    end

    # guarantee that always response json
    respond_to do |format|
      format.json {render :json => msg}
    end
  end

  def save_order
    add_dish_params
    if params[:dish][:action] == "add"
      add_dish_to_order (true)
    else
      remove_dish_from_order(true)
    end
  end

  def remove_dish_from_order(isAjax)
    unless session[:today_order].nil?
      @order_dishes = DishOrder.where(order_id: session[:today_order_id]).where(dish_id: params[:dish][:dish_id]).all
      @order_dishes.first.destroy if @order_dishes.length >=1
    end

    # guarantee that always response json
    respond_to do |format|
      msg = {:status => "ok", :message => "Success!", :html => "<b>...</b>", today: session[:today_order]}
      format.json {render :json => msg}
    end
  end

  def add_dish_to_order_no_ajax
    add_dish_to_order_params
    order = Order.find(session[:today_order_id])
    unless order.blank?
      dish_order = DishOrder.new(order_id: session[:today_order_id], dish_id: params[:dish_id])
      if dish_order.save
        redirect_to order_user_path(session[:user_id])
      end
    end
  end

  def add_dish
    redirect_to '/users/test'
  end

  def edit_note
    order_id = session[:today_order_id]
    @order = Order.find(order_id)
    if @order.update(edit_note_params)
      msg = {status: "ok"}
    else
      msg = {status: "fail"}
    end
    respond_to do |format|
      format.json {render :json => msg}
    end
  end

  def copy_order
    copy_info_params
    # delete all current dishes of current user
    current_order_id =session[:today_order_id]
    @dish_orders = DishOrder.where(order_id: current_order_id).all
    @dish_orders.each do |d|
      d.destroy
    end

    # add all copied dishes follow copied user
    unless params[:copy_info][:dish_ids].blank?
      params[:copy_info][:dish_ids].each do |d|
        @dish_order = DishOrder.new(order_id: current_order_id, dish_id: d)
        @dish_order.save
      end
    end

    # update note
    @order = Order.find(current_order_id)
    unless @order.blank?
      @order.update_attributes(note: params[:copy_info][:note])
    end
    redirect_to order_user_path(session[:user_id])
  end


  def test
=begin
    m = Menu.find_by_date(Date.today)
    @restaurants = m.restaurants
    @dishes = m.restaurants.map(&:dishes).flatten

    @slice_dishes = @dishes.each_slice(ApplicationHelper::NUMBER_OF_DISH_PER_PAGE).to_a
=end
  end

  def test_ajax
    users = User.where("email LIKE ? ", "%#{params[:keyword]}%").limit(10)
    respond_to do |format|
      format.json {render :json => {status: "ok", users: users}}
    end
  end

  def get_dish

  end

  private

  def add_dish_to_order_params
    params.permit(:dish_id)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def add_dish_params
    params.require(:dish).permit(:user_id, :dish_id, :action, :order_id)
  end

  def edit_note_params
    params.require(:order).permit(:order_id, :note)
  end

  def copy_info_params
    params.require(:copy_info).permit(:dish_ids, :user_id, :order_id, :note)
  end

  def check_user_permission(editted_user_id)''
    unless editted_user_id == session[:user_id]
      @error = ErrorCode::ERR_DENY_EDIT_PERMISSION
      render 'layouts/error'
    end
  end
end


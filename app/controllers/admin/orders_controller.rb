class Admin::OrdersController < AdminsController
  def edit
    @order = Order.find(params[:id])
  end

  def update
  end

  def show
    @order = Order.find(params[:id])
  end

  def index
    redirect_to get_all_orders_today_users_path
  end

  def create
    @order = Order.new(create_order_params)
    if @order.save
      params[:order][:dish_ids].each do |dish_id|
        DishOrder.create(dish_id: dish_id, order_id: @order.id)
      end
      redirect_to get_all_orders_today_users_path
    else
      render plain: "Create order fail"
    end
  end

  def new
    _get_dishes_of_menu_by_date(Date.today)
    byebug
  end

  def destroy
    @order = Order.find(params[:id])
    @dish_order = DishOrder.where("order_id=?", @order.id)
    unless @dish_order.blank?
      @dish_order.destroy_all
    end
    @order.destroy
    redirect_to get_all_orders_today_users_path
  end

  def ajax_get_dishes_by_date
    _get_dishes_of_menu_by_date(params[:date])
    if defined? @menu
      res = {status: "fail", menu: @menu}
    else
      res = {status: "ok", slice_dishes: @slice_dishes}
    end
    respond_to do |format|
      format.json {render :json => res}
    end
  end

  private
  def create_order_params
    dish_ids = params[:order][:dishes][0].split(",")
    params[:order][:dish_ids] = dish_ids

    params.require(:order).permit(:note, :date, :user_id, :dish_ids, :total_price)
    #params[:order][:date] = Date.civil(params[:orders]["date(1i)"].to_i, params[:orders]["date(2i)"].to_i, params[:orders]["date(3i)"].to_i)
  end

  def _get_dishes_of_menu_by_date(date)
    @order = Order.new
    m = Menu.find_by_date(date)
    if m
      @restaurants = m.restaurants
      @dishes = m.restaurants.map(&:dishes).flatten
      @slice_dishes = @dishes.each_slice(ApplicationHelper::NUMBER_OF_DISH_PER_PAGE).to_a
    else
      @menu = null
    end
  end
end
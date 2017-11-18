class Admin::OrdersController < Admin::AdminsController
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

    #params[:order][:dish_ids].each do |dish_id|
    #  DishOrder.create(dish_id: dish_id, order_id: @order.id)
    #end

    raise MyError::CreateFailError.new @order.errors.messages unless @order.save
  end

  def new
    _get_dishes_of_menu_by_date(Date.today)
    render 'menus/request_menu' if defined? @menu
  end

  def destroy
    @order = Order.find(params[:id])
    @dish_order = DishOrder.where('order_id=?', @order.id)
    @dish_order.destroy_all unless @dish_order.blank?
    @order.destroy
    redirect_to get_all_orders_today_users_path
  end

  def ajax_get_dishes_by_date
    date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    _get_dishes_of_menu_by_date(date)
    res = defined? @menu ? {status: 'fail', menu: @menu} : {status: 'ok', slice_dishes: @slice_dishes}
    respond_to do |format|
      format.json {render :json => res}
    end
  end

  def export_pdf
    @orders = Order.where('DATE(date)=?', Date.today).all
    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrderPdf.new(@orders)
        send_data pdf.render, filename: 'order_report.pdf', type: 'application/pdf'
      end
    end
  end

  private
  def create_order_params
    dish_ids = params[:order][:dishes][0].split(',')
    params[:order][:dish_ids] = dish_ids
    params.require(:order).permit(:note, :date, :user_id, :total_price, :dish_ids => [])
    #params[:order][:date] = Date.civil(params[:orders]['date(1i)'].to_i, params[:orders]['date(2i)'].to_i, params[:orders]['date(3i)'].to_i)
  end

  def _get_dishes_of_menu_by_date(date)
    @order = Order.new
    m = Menu.find_by_date(date)
    if m
      @restaurants = m.restaurants
      @dishes = m.restaurants.map(&:dishes).flatten
      @dishes.map {|dish| dish.image=nil}
      @slice_dishes = @dishes.each_slice(ApplicationHelper::NUMBER_OF_DISH_PER_PAGE).to_a
    else
      @menu = nil
    end
  end
end
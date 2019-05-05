class DashboardsController < ApplicationController
  layout 'dashboard'
  before_action :require_login

  def index
    # select_date = select_date_params[:select_date]
    # select_date = select_date ? Date.parse(select_date) : Date.today

    # @menu = Menu.where('DATE(date)=?', select_date).first
    # @select_date = select_date

    # return if @menu.blank?
    # if select_date < Date.today ||
    #     (select_date == Date.today && @menu.is_lock? && Time.current > @menu.locked_at)
    #   @locked = true
    #   @locked_time = @menu.locked_at
    #   return
    # end

    # @today_order = Orders::RetrieveService.find_order_by_user_id_and_date session[:user_id], select_date

    # @r_tags = Menus::RetrieveService.new(@menu).collect_follow_tags_for_each_restaurant

    # @total_price = @today_order.blank? ? 0 : @today_order.cal_total_price

    # @all_orders = Order.where('DATE(date)=?', select_date)

    # @available_restaurants = @menu.available_restaurants(Time.current)
    # @avg_cost_on_month = AverageCostService.call(current_user.id)
    # num_day_of_month = ParseDateService.weekdays_in_month_given_a_date(Date.current)
    # @total_allow_budget_for_month = num_day_of_month * Order::MONTH_AVG_LIMIT
  end
end

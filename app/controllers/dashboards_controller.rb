class DashboardsController < ApplicationController
  layout 'dashboard'
  before_action :require_login

  def index
    @select_date = Date.parse(params[:select_date].presence || Date.today.to_s)
    @menu = Menu.where('DATE(date)=?', @select_date).first

    return if @menu.blank?
    if @select_date < Date.today ||
        (@select_date == Date.today && @menu.is_lock? && Time.current > @menu.locked_at)
      @locked = true
      @locked_time = @menu.locked_at
      return
    end

    @r_tags = Menus::RetrieveService.new(@menu).collect_follow_tags_for_each_restaurant
    @all_orders = Order.where('DATE(date)=?', @select_date)
    @available_restaurants = @menu.available_restaurants(Time.current)
  end
end

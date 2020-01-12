# frozen_string_literal: true

class DashboardsController < ApplicationController
  layout 'dashboard'
  before_action :require_login

  def index
    @select_date = Date.parse(params[:select_date].presence || Date.today.to_s)
    @menu = Menu.where('DATE(date)=?', @select_date).first
    return if @menu.blank?

    @r_tags = Menus::RetrieveService.new(@menu).collect_follow_tags_for_each_restaurant
    @available_restaurants = @menu.available_restaurants(Time.current)

    @current_order = current_user.orders.where(date: @select_date).take
  end

  ### Temporary place these actions here for refactor orders_controller later
  def create_order
    service = OrderServices::AddDish.new(current_user.id, params[:dish_id], params[:select_date], Time.current)
    service.call

    msg = if service.success?
            { status: 'success', message: 'success' }
          else
            { status: 'fail', message: service.errors }
          end

    msg[:today] = session[:today_order] if msg[:status] == 'success'
    @order = service.order

    respond_to do |format|
      format.json { render json: msg }
    end
  end
end

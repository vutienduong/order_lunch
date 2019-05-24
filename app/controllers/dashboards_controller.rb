# frozen_string_literal: true

class DashboardsController < ApplicationController
  layout 'dashboard'
  before_action :require_login

  STATUS_OK = 'ok'.freeze
  STATUS_FAIL = 'fail'.freeze
  MSG_SUCCESS = 'Success!'.freeze

  def index
    @select_date = Date.parse(params[:select_date].presence || Date.today.to_s)
    @menu = Menu.where('DATE(date)=?', @select_date).first
    return if @menu.blank?

    @r_tags = Menus::RetrieveService.new(@menu).collect_follow_tags_for_each_restaurant
    @available_restaurants = @menu.available_restaurants(Time.current)
  end

  ### Temporary place these actions here for refactor orders_controller later
  def create_order
    service = OrderServices::AddDish.new(current_user.id, params[:dish_id], params[:select_date], Time.current)
    service.call

<<<<<<< HEAD
    msg = service.success? ? { status: 'ok', message: 'Success!' } : { status: 'fail', message: service.errors }

    msg[:today] = session[:today_order] if msg[:status] == 'ok'
=======
    msg = if service.success?
            { status: STATUS_OK, message: MSG_SUCCESS }
          else
            { status: STATUS_FAIL, message: service.errors }
          end

    msg[:today] = session[:today_order] if msg[:status] == STATUS_OK
>>>>>>> 1f71385f889936f6309f0450f4c3e097b3623165
    @order = service.order

    respond_to do |format|
      format.json { render json: msg }
    end
  end
end

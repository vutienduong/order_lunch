class OrdersController < ApplicationController
  include MyError
  include ApplicationHelper
  before_action :require_login

  def show_personal_orders
    @page = page_param[:page].to_i
    @page = 1 if @page.blank? || @page.zero?
    @orders = Order.where(user_id: session[:user_id]).order(date: :desc)
                  .limit(NUMBER_OF_ORDER_PER_PAGE)
                  .offset((@page - 1) * NUMBER_OF_ORDER_PER_PAGE)
    @num_of_pages = (Order.where(user_id: session[:user_id]).order(date: :desc).count / NUMBER_OF_MENU_PER_PAGE.to_f).ceil
    render 'orders/personal_order'
  end

  def order_custom_salad
    @order = Order.new
    @dish = Dish.new
    @components = DishedComponent.all.group_by &:category

    @other_custom = Dish.all.where(componentable: true)
  end

  def create_custom_salad
    new_name = generate_custom_salad_name(params[:dish][:name])
    if Dish.find_by(name: new_name).present?
      msg = { status: STATUS_FAIL, fail_type: 'EXISTED_NAME', message: 'Name of dish has been existed, please choose another name' }
      response_to_json msg
      return
    end

    components = params[:quant].each_with_object({}) { |k, h| h[k.first] = k.last.reject { |_s, h| h.eql? "0" } }

    # component_ids = params[:component_ids].map {|k, v| v}.flatten

    component_id_with_quants = components.values

    # component_ids = components.map{|k,v|v.keys }.flatten

    components_ids = component_id_with_quants.reject(&:blank?) # remove {} if one component group has been not chosen
    component_ids = components_ids.map { |k| k.map { |dk| Array.new(dk.last.to_i) { dk.first } } }.flatten
    component_ids = component_ids.map(&:to_i).sort

    if component_ids.blank?
      msg = { status: STATUS_FAIL, fail_type: 'EMPTY_COMBO', message: 'List of components empty, please choose at least one' }
      response_to_json msg
      return
    end

    # get all other custom salad
    other_custom_salads = Dish.all.where(componentable: true)
    salad_combo_id_list = order_custom_salad.map { |cs| { cs => cs.dished_component_ids.sort } }
    # compare existed
    existed_combo = salad_combo_id_list.select { |d| d.first.last.eql? component_ids }

    if existed_combo.blank?
      # if not exist, create and redirect to success page
      begin
        restaurant_id = Restaurant.where('name like "%salad%" ').first.id
        d = Dish.new(custom_salad_params)
        d.restaurant_id = restaurant_id
        d.componentable = true
        d.dished_component_ids = component_ids
        d.description = build_note_for_custom_salad components
        d.name = generate_custom_salad_name d.name
        d.save
      rescue => e
        # raise MyError::CreateFailError.new e.message
        msg = { status: STATUS_FAIL, message: e.message }
        response_to_json msg
      end

      msg = { status: STATUS_OK, message: "Create custom salad #{d.name} successful, with components #{d.description}.", data: d }
      response_to_json msg
      return

      # @dish = d
      # render 'create_custom_salad_success'
    else
      # if existed, redirect to confirm page
      # redirect_to confirm_create_same_combo_orders_path

      existed_salad = existed_combo.first.first.first
      msg = { status: STATUS_FAIL, fail_type: 'SAME_COMBO', message: "Components of this salad is same as [#{existed_salad.name}]. Do you still want to create new salad custom dish with new name [OK], or use existed salad custom combo? [Cancel]", data: { dish: existed_salad, new_name: new_name } }

      response_to_json msg
      # @dish = existed_combo
      # render 'confirm_create_same_combo'
    end
  end

  def check_custom_salad_name
    msg = Dish.find_by(name: generate_custom_salad_name(params[:salad_name])).blank? ? { status: STATUS_OK, message: MSG_SUCCESS } : { status: STATUS_FAIL }
    response_to_json msg
  end

  def create_custom_salad_with_name
    begin
      dish = Dish.find_by(dish_id_params)
      new_dish = dish.dup
      new_dish.name = params[:new_name]
      new_dish.dished_component_ids = dish.dished_component_ids
      new_dish.save
      msg = { status: STATUS_OK, message: MSG_SUCCESS }
    rescue => e
      msg = { status: STATUS_FAIL, message: e.message }
    end
    response_to_json msg
  end

  private

  def custom_salad_params
    params.require(:dish).permit(:name, :price)
  end

  def salad_params
    params.permit(:salad_name)
  end

  def dish_id_params
    params.require(:dish).permit(:id)
  end

  def page_param
    params.permit(:page)
  end
end

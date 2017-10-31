class RestaurantsController < ApplicationController
  def show
    @restaurant = Restaurant.includes(:dishes).find(params[:id])
    @today_order = Order.find(session[:today_order_id])
  end

  def show_detail
    @restaurant = Restaurant.includes(:dishes).find(params[:id])
    render 'show_dish_details'
  end

  def index
    @restaurants = Restaurant.includes('dishes').all
    #render plain: @restaurants.inspect
  end
end

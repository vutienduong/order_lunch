class OrdersController < ApplicationController
  def show_personal_orders
    @orders = Order.where(user_id: session[:user_id]).all
    render 'orders/personal_order'
  end
end
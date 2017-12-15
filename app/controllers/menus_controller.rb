class MenusController < ApplicationController
  before_action :require_login
  def index
    @menus = Menu.all.order(date: :desc)
  end

  def show
    @menu = Menu.includes(:restaurants).find(params[:id])
  end

  private
  def menu_params
    params.require(:menu).permit(:date, :restaurant_ids => [])
  end
end

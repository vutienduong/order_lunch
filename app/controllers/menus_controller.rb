class MenusController < ApplicationController
  def index
    @menus = Menu.all
  end

  def show
    @menu = Menu.includes(:restaurants).find(params[:id])
  end

  private
  def menu_params
    params.require(:menu).permit(:date, :restaurant_ids => [])
  end
end

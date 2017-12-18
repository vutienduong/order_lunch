class MenusController < ApplicationController
  before_action :require_login
  include ApplicationHelper

  def index
    @page = page_param[:page].to_i
    @page = 1 if @page.blank? || @page.zero?
    @menus = Menu.order(date: :desc)
                 .limit(NUMBER_OF_MENU_PER_PAGE)
                 .offset((@page - 1) * NUMBER_OF_MENU_PER_PAGE)
    @num_of_pages = (Menu.count/NUMBER_OF_MENU_PER_PAGE.to_f).ceil
  end

  def show
    @menu = Menu.includes(:restaurants).find(params[:id])
  end

  private
  def menu_params
    params.require(:menu).permit(:date, :restaurant_ids => [])
  end

  def page_param
    params.permit(:page)
  end
end

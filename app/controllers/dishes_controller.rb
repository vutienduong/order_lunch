class DishesController < ApplicationController
  before_action :require_login
  def index
    @dishes = Dish.all
  end

  def show
    @dish = Dish.find(params[:id])
  end
end

class FoodsController < ApplicationController
  before_action :require_login
  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    if @food.save
      redirect_to @food
    else
      render params.inspect
    end
  end

  def index
    @foods = Food.all
  end

  def export_pdf
    @foods = Food.all
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(@foods)
        send_data pdf.render, filename: 'order_report.pdf', type: 'application/pdf'
      end
    end
  end

  def edit
    @food = Food.find(params[:id])
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    redirect_to foods_path
  end

  def update
    @food = Food.find(params[:id])
    #render params.inspect

    #return
    if @food.update(food_params)
      redirect_to @food
    else
      render 'edit'
    end
  end

  def show
    @food = Food.find(params[:id])
  end

  private
  def food_params
    params.require(:food).permit(:title, :description, :creator, :date)
  end
end

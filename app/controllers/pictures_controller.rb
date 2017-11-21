class PicturesController < ApplicationController
  include MyError
  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new picture_params
    raise MyError::CreateFailError unless @picture.save
    redirect_to picture_path @picture.id
  end

  def index
    @pictures = Picture.all
  end

  def show
    @picture = Picture.find params[:id]
  end

  private

  def picture_params
    params.require(:picture).permit(:name, :image)
  end
end

class Admin::RestaurantsController < AdminsController
  #require 'services/upload_image'
  def new
    @restaurant = Restaurant.new
    render 'restaurants/new'
  end

  def create
    require Rails.root.join('app/services/upload_image')
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.image_logo = ''
    if @restaurant.save
      uploaded_io = params[:restaurant][:image_logo]
      file_name = Pathname('').join('restaurants', "#{@restaurant.id}_#{uploaded_io.original_filename}")
      OLUploadImage.upload(file_name, uploaded_io)

      @restaurant.update_attributes(image_logo: file_name)
      redirect_to restaurant_path(@restaurant)
    else
      render "Error edit restaurant"
    end
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :image_logo)
  end
end
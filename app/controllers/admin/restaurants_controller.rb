class Admin::RestaurantsController < AdminsController
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
      unless uploaded_io.blank?
        file_name = Pathname('').join('restaurants', "#{@restaurant.id}_#{uploaded_io.original_filename}")
        OLUploadImage.upload(file_name, uploaded_io)

        @restaurant.update(image_logo: file_name)
      end

      redirect_to restaurant_path(@restaurant)
    else
      render "Error create restaurant"
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    require Rails.root.join('app/services/upload_image')
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
      uploaded_io = params[:restaurant][:image_logo]
      unless uploaded_io.blank?
        file_name = Pathname('').join('restaurants', "#{@restaurant.id}_#{uploaded_io.original_filename}")
        OLUploadImage.upload(file_name, uploaded_io)
        @restaurant.update(image_logo: file_name)
      end
      redirect_to restaurants_path(@restaurant)
    else
      render "Error edit restaurant"
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.dishes.destroy_all
    @restaurant.destroy

    #TODO: delete image resource of this restaurant
    redirect_to restaurants_path
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :image_logo, :phone)
  end
end
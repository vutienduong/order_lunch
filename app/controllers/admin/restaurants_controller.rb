class Admin::RestaurantsController < Admin::AdminsController
  def new
    @restaurant = Restaurant.new
    render 'restaurants/new'
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.image_logo = ''
    raise MyError::CreateFailError.new @restaurant.errors.messages unless @restaurant.save
    #uploaded_io = params[:restaurant][:image_logo]
    #upload_image_after_create_restaurant(uploaded_io, @restaurant)
    redirect_to restaurant_path(@restaurant)
  end

  def index
    @restaurants = Restaurant.includes('dishes').all
    render 'restaurants/index'
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    raise MyError::CreateFailError.new @restaurant.errors.messages unless @restaurant.update restaurant_params
    #uploaded_io = params[:restaurant][:image_logo]
    #upload_image_after_create_restaurant(uploaded_io, @restaurant)
    redirect_to restaurant_path(@restaurant)
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.dishes.destroy_all
    @restaurant.destroy
    redirect_to restaurants_path
  end

  def show_image
    @restaurant = Restaurant.find(params[:id])
    send_data @restaurant.image, :type => 'image/png', :disposition => 'inline'
  end

  private
  def restaurant_params
    unless params[:restaurant][:image_logo].blank?
      params[:restaurant][:image] = params[:restaurant][:image_logo].tempfile.read
    end
    params.require(:restaurant).permit(:name, :address, :phone, :image)
  end

  def upload_image_after_create_restaurant(uploaded_io, restaurant)
    require Rails.root.join('app/services/upload_image')
    unless uploaded_io.blank?
      file_name = Pathname('').join('restaurants', "#{restaurant.id}_#{uploaded_io.original_filename}")
      OLUploadImage.upload(file_name, uploaded_io)
      restaurant.update(image_logo: file_name)
    end
  end
end
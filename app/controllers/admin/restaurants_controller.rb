class Admin::RestaurantsController < Admin::AdminsController
  include Scraper
  include MyError
  FOODY_HOST = 'www.foody.vn'
  MISSING_LINK_MSG = 'Can\' scrap because missing Foody link'.freeze
  NOT_FOODY_MGS = 'Reference link of resraurant is not belonged to Foody provider'

  def new
    @restaurant = Restaurant.new
    render 'restaurants/new'
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    # @restaurant.image_logo = ''
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

  def scrap_dish
    scrap_params
    @restaurant = Restaurant.find_by id: params[:id]
    raise MyError::NonExistRecordError.new 'Restaurant ID is not existed' unless @restaurant
    raise MyError::CreateFailError.new MISSING_LINK_MSG if @restaurant.ref_link.blank?
    res_url = @restaurant.ref_link
    after = 'goi-mon'
    full_url = File.join res_url, after
    @log = {}

    if URI(res_url).host.eql? FOODY_HOST
      a = Scraper::FoodyScraper.new.crawl full_url

      @dishes = a['dishes']
      @coupon = a['coupon']
      begin
        @dishes = @dishes.map do |dish|
          adish = Dish.create(
              name: dish['dish_name'],
              price: (dish['price'].to_d)*1000,
              description: dish['dish_desc'],
              restaurant: @restaurant)
          adish.image_logo_remote_url = dish['img_src']
          adish.save
          adish
        end
        @log[:success] = "Create dishes for restaurant #{@restaurant.name} successful!"
      rescue => e
        @log[:exception] = e.message
      end
    else
      raise MyError::CreateFailError.new NOT_FOODY_MGS
    end
  end

  private
  def restaurant_params
    # unless params[:restaurant][:image_logo].blank?
    #   params[:restaurant][:image] = params[:restaurant][:image_logo].tempfile.read
    # end
    params.require(:restaurant).permit(:name, :address, :phone, :image_logo, :ref_link)
  end

  def scrap_params
    params.permit(:id, :ref_link)
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
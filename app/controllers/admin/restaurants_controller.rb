class Admin::RestaurantsController < Admin::AdminsController
  include Scraper
  include MyError
  FOODY_HOST = 'www.foody.vn'
  THUAN_KIEU_HOST = 'comtamthuankieu.com.vn'
  MISSING_LINK_MSG = 'Can\' scrap because missing Foody link'.freeze
  NOT_REGISTERED_MGS = 'Reference link of resraurant is not belonged to registered provider'
  NO_DISH_IMG_PATTERN = 'deli-dish-no-image.png'

  def new
    @restaurant = Restaurant.new
    render 'restaurants/new'
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    # @restaurant.image_logo = ''
    raise MyError::CreateFailError, @restaurant.errors.messages unless @restaurant.save
    # uploaded_io = params[:restaurant][:image_logo]
    # upload_image_after_create_restaurant(uploaded_io, @restaurant)
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
    raise MyError::CreateFailError, @restaurant.errors.messages unless @restaurant.update restaurant_params
    # uploaded_io = params[:restaurant][:image_logo]
    # upload_image_after_create_restaurant(uploaded_io, @restaurant)
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
    send_data @restaurant.image, type: 'image/png', disposition: 'inline'
  end

  def scrap_dish
    scrap_params
    @restaurant = Restaurant.find_by id: params[:id]
    raise MyError::NonExistRecordError, 'Restaurant ID is not existed' unless @restaurant
    raise MyError::CreateFailError, MISSING_LINK_MSG if @restaurant.ref_link.blank?
    res_url = @restaurant.ref_link
    after = 'goi-mon'
    full_url = File.join res_url, after
    @log = {}

    if URI(res_url).host.eql? FOODY_HOST
      a = Scraper::FoodyScraper.new.crawl full_url
      begin
        tags = a['tags']
        tags.each do |tag|
          tag_name = tag['tag_name']
          tag_obj = Tag.find_by name: tag_name
          tag_obj ||= Tag.create(name: tag_name)

          @dishes = tag['dishes']
          @dishes = @dishes.map do |dish|
            if adish = Dish.where(name: dish['dish_name']).where(restaurant_id: @restaurant.id).first
              old_tags = adish.tags
              new_tags = old_tags.include? tag_obj ? old_tags : old_tags.push(tag_obj)
              adish.update tags: new_tags
              adish.save
            else
              adish = Dish.create(
                name: dish['dish_name'],
                price: dish['price'].to_d * 1000,
                description: dish['dish_desc'],
                restaurant: @restaurant, tags: [tag_obj]
              )
              adish.image_logo_remote_url = dish['img_src'] unless dish['img_src'].include? NO_DISH_IMG_PATTERN
              adish.save
            end
            adish
          end
        end
        @log[:success] = "Create dishes for restaurant #{@restaurant.name} successful!"
      rescue => e
        @log[:exception] = e.message
      end

    elsif URI(res_url).host.include? THUAN_KIEU_HOST
      pre_url = File.join(res_url, '?page=')
      full_urls = %w[1 2].map { |n| pre_url + n }
      @dishes = []
      full_urls.each do |full_url|
        a = Scraper::Thuan_Kieu_Scraper.new.crawl full_url
        @dishes += a['dishes']
      end

      @dishes.each { |d| d['price'].gsub!(' VND', '').delete!(',') }

      begin
        @dishes = @dishes.map do |dish|
          adish = Dish.create(
            name: dish['dish_name'],
            price: dish['price'].to_d,
            restaurant: @restaurant
          )
          adish.image_logo_remote_url = dish['img_src'] unless dish['img_src'].include? NO_DISH_IMG_PATTERN
          adish.save
          adish
        end
        @log[:success] = "Create dishes for restaurant #{@restaurant.name} successful!"
      rescue => e
        @log[:exception] = e.message
      end
    else
      raise MyError::CreateFailError, NOT_REGISTERED_MGS
    end
  end

  private

  def restaurant_params
    # unless params[:restaurant][:image_logo].blank?
    #   params[:restaurant][:image] = params[:restaurant][:image_logo].tempfile.read
    # end
    params.require(:restaurant).permit(:name, :address, :phone, :image_logo, :ref_link, :description, :is_provider)
  end

  def scrap_params
    params.permit(:id, :ref_link)
  end

  def upload_image_after_create_restaurant(uploaded_io, restaurant)
    require Rails.root.join('app/services/upload_image')
    if uploaded_io.present?
      file_name = Pathname('').join('restaurants', "#{restaurant.id}_#{uploaded_io.original_filename}")
      OLUploadImage.upload(file_name, uploaded_io)
      restaurant.update(image_logo: file_name)
    end
  end
end

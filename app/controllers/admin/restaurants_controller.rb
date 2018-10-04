class Admin::RestaurantsController < Admin::AdminsController
  include Scraper
  include MyError
  FOODY_HOST = 'www.foody.vn'
  THUAN_KIEU_HOST = 'comtamthuankieu.com.vn'
  MISSING_LINK_MSG = 'Can\' scrap because missing Foody link'.freeze
  NOT_REGISTERED_MGS = 'Reference link of resraurant is not belonged to registered provider'
  NO_DISH_IMG_PATTERN = 'deli-dish-no-image.png'
  ORDER_DISH_POSTFIX = 'goi-mon'

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
    unless @restaurant.update restaurant_params
      raise MyError::CreateFailError, @restaurant.errors.messages
    end
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

  def complete_image
    @restaurant = Restaurant.find params[:id]
    full_url = if @restaurant.ref_link.to_s.include? ORDER_DISH_POSTFIX
                 @restaurant.ref_link
               else
                 File.join(@restaurant.ref_link, ORDER_DISH_POSTFIX)
               end
    scrap_data = Scraper::FoodyScraper.new.crawl(full_url)
    categories = scrap_data['tags']
    categories.each do |category|
      dishes = category['dishes']
      dishes.each do |dish|
        price = dish['price'].to_d * 1000
        ol_dish = Dish.find_by(name: dish['dish_name'],
                               restaurant_id: @restaurant.id,
                               price: price)
        unless ol_dish
          Rails.logger.info "Ignore '#{dish['dish_name']}'"
          next
        end

        if !dish['img_src'].include?(NO_DISH_IMG_PATTERN) && ol_dish.image_logo_remote_url.nil?
          ol_dish.image_logo_remote_url = dish['img_src']
          Rails.logger.info "Complete image success: '#{dish['dish_name']}'" if ol_dish.save
        end
      end
    end

    redirect_to restaurant_path(id: @restaurant.id)
  end

  def scrap_dish
    scrap_params
    @restaurant = Restaurant.find_by id: params[:id]
    raise MyError::NonExistRecordError, 'Restaurant ID is not existed' unless @restaurant
    raise MyError::CreateFailError, MISSING_LINK_MSG if @restaurant.ref_link.blank?
    res_url = @restaurant.ref_link
    full_url = File.join res_url, ORDER_DISH_POSTFIX
    @log = {}

    if URI(res_url).host.eql? FOODY_HOST
      a = Scraper::FoodyScraper.new.crawl full_url
      begin
        tags = a['tags']
        tags.each do |tag|
          tag_name = tag['tag_name']
          tag_obj = Tag.find_by name: tag_name || Tag.create(name: tag_name)

          @dishes = tag['dishes']
          @dishes = @dishes.map do |dish|
            adish = Dish.find_by(name: dish['dish_name'], restaurant_id: @restaurant.id)

            if adish
              old_tags = adish.tags
              old_tags << tag_obj unless old_tags.include? tag_obj
              # adish.update tags: new_tags
            else
              adish = Dish.create(
                name: dish['dish_name'],
                price: dish['price'].to_d * 1000,
                description: dish['dish_desc'],
                restaurant: @restaurant, tags: [tag_obj]
              )
              unless dish['img_src'].include? NO_DISH_IMG_PATTERN
                adish.image_logo_remote_url = dish['img_src']
              end
            end
            adish.save
            adish
          end
        end
        @log[:success] = "Create dishes for restaurant #{@restaurant.name} successful!"
      rescue StandardError => e
        @log[:exception] = e.message
      end

    elsif URI(res_url).host.include? THUAN_KIEU_HOST
      pre_url = File.join(res_url, '?page=')
      full_urls = %w[1 2].map { |n| pre_url + n }
      @dishes = []
      full_urls.each do |f_url|
        a = Scraper::Thuan_Kieu_Scraper.new.crawl f_url
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

          unless dish['img_src'].include? NO_DISH_IMG_PATTERN
            adish.image_logo_remote_url = dish['img_src']
          end

          adish.save
          adish
        end
        @log[:success] = "Create dishes for restaurant #{@restaurant.name} successful!"
      rescue StandardError => e
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
    params.require(:restaurant).permit(:name, :address, :phone, :image_logo,
                                       :ref_link, :description, :is_provider)
  end

  def scrap_params
    params.permit(:id, :ref_link)
  end

  def upload_image_after_create_restaurant(uploaded_io, restaurant)
    require Rails.root.join('app', 'services', 'upload_image')
    if uploaded_io.present?
      file_name = Pathname('').join('restaurants',
                                    "#{restaurant.id}_#{uploaded_io.original_filename}")
      OLUploadImage.upload(file_name, uploaded_io)
      restaurant.update(image_logo: file_name)
    end
  end
end

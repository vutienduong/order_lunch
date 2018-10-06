module ImageUploadServices
  class ImportMissing
    FOODY_HOST = 'www.foody.vn'
    ORDER_DISH_POSTFIX = 'goi-mon'
    NO_DISH_IMG_PATTERN = 'deli-dish-no-image.png'
    MAX_TRIES_ONCE = 5

    class << self
      def call(*args)
        new(*args).call
      end
    end

    def initialize; end

    def call
      @count = 0
      ::Restaurant.find_each do |restaurant|
        if restaurant.ref_link&.include? FOODY_HOST
          if restaurant.dishes.any? { |dish| dish.image_logo_file_name.nil? }
            import_missing_image(restaurant)
            return true if @count == MAX_TRIES_ONCE
          end
        end
      end
    end

    private

    def import_missing_image(restaurant)
      full_url = if restaurant.ref_link.include? ORDER_DISH_POSTFIX
                   restaurant.ref_link
                 else
                   File.join(restaurant.ref_link, ORDER_DISH_POSTFIX)
                 end
      data = Scraper::FoodyScraper.new.crawl(full_url)
      tags = data['tags']
      tags.each do |tag|
        dishes = tag['dishes']
        dishes.each do |dish|
          ol_dish = Dish.find_by(name: dish['dish_name'], restaurant_id: restaurant.id)
          if ol_dish&.no_logo? && !(dish['img_src'].include? NO_DISH_IMG_PATTERN)
            Rails.logger.info "Save image for [Dish] '#{ol_dish.name}',"\
                              " [Restaurant] '#{restaurant.name}'"
            ol_dish.image_logo_remote_url = dish['img_src']
            ol_dish.save
            @count += 1
            return true if @count == MAX_TRIES_ONCE
          else
            Rails.logger.info "Skip [Dish] '#{ol_dish.name}'"
          end
        end
      end
    end
  end
end

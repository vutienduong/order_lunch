module ScrapServices
  class FoodyApi < ServiceBase
    NO_DISH_IMG_PATTERN = 'deli-dish-no-image.png'.freeze

    attr_accessor :payload, :restaurant
    attr_reader :dishes, :log

    def self.call(*args)
      new(*args).call
    end

    def initialize(payload: {}, restaurant_id: nil)
      @payload = payload
      @restaurant = Restaurant.find(restaurant_id)
      @log = {}
    end

    def call
      fd = FdHeader.new(payload: payload)
      response = RestClient::Request.execute(method: :get, url: fd.url, headers: fd.header)
      response = JSON.parse(response).with_indifferent_access
      if response['result'] != 'success'
        add_errors('Request fail')
      else
        begin
          all_tags = response.dig(:reply, :menu_infos)
          all_tags.each do |tag|
            tag_name = tag['dish_type_name']
            tag_external_id = tag['dish_type_id']
            tag_obj = Tag.where(name: tag_name, external_id: tag_external_id).first_or_create!
            dishes = tag['dishes']
            dishes.each do |dish|
              dish_external_id = dish['id']
              dish_name = dish['name']
              dish_price = dish.dig(:price, :value)
              dish_desc = dish['description']

              # TODO: should use restaurant.dishes.find_by
              new_dish = Dish.find_by(name: dish_name, restaurant_id: restaurant.id)
              if new_dish
                old_tags = new_dish.tags
                old_tags << tag_obj unless old_tags.include? tag_obj
              else
                adish = Dish.create(
                  name: dish_name,
                  price: dish_price.to_d,
                  description: dish_desc,
                  restaurant: restaurant,
                  external_id: dish_external_id,
                  tags: [tag_obj]
                )
                dish_img = dish['photos'][2]['value']
                unless dish_img.include? NO_DISH_IMG_PATTERN
                  adish.image_logo_remote_url = dish_img
                  adish.save
                end
              end
            end
          end
          @log[:success] = "Create dishes for restaurant #{restaurant.name} successful!"
        rescue StandardError => e
          add_errors(e.message)
          @log[:exception] = e.message
        end
      end
    end
  end
end

module OrderServices
  class AddDish
    attr_reader :order, :user_id, :dish_id, :date, :checked_time, :errors

    class << self
      def call(*args)
        new(*args).call
      end
    end

    def initialize(user_id, dish_id, date, checked_time)
      @user_id = user_id
      @dish_id = dish_id
      @date = date
      @checked_time = checked_time
    end

    def call
      @order = Orders::RetrieveService.find_order_by_user_id_and_date(user_id, date)
      menu = Menu.where('DATE(date)=?', date).first
      dish = Dish.find_by(id: dish_id)

      if dish.blank?
        @errors = I18n.t('order.errors.dish_not_exist')
        return
      end

      unless Orders::ValidationService.validate_add_dish?(checked_time, dish, menu)
        @errors = I18n.t('order.errors.restaurant_has_locked',
                         restaurant: dish.restaurant.name)
        return
      end

      @order = Order.create!(user_id: user_id, date: date) if @order.blank?
      @order_dish = DishOrder.new(order_id: @order.id, dish_id: dish_id)

      unless @order_dish.save
        @errors = I18n.t('order.errors.save_to_order_failed')
        return
      end

      @order.update(total_price: @order.cal_total_price)
    end

    def success?
      @errors.blank?
    end
  end
end

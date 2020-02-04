module ApplicationHelper
  include Pagy::Frontend

  NUMBER_OF_DISH_PER_PAGE = 30
  STATUS_OK = 'ok'.freeze
  STATUS_FAIL = 'fail'.freeze
  MSG_SUCCESS = 'Success!'.freeze
  MAX_TAG_OPTION_NUMBER = 15
  NUMBER_OF_MENU_PER_PAGE = 15
  NUMBER_OF_ORDER_PER_PAGE = 10


  def display_cost_as_thousand(cost)
    "#{(cost/1000).to_i},000"
  end

  def date_format(date)
    date.gregorian
  end

  def page_title(name)
    render html: "<h1>#{name}</h1>".html_safe
  end

  def show_id_included_blank prefix_id, obj
    obj.blank? ? "#{prefix_id}_nil" : "#{prefix_id}_#{obj.id.to_s}"
  end

  def parse_date_string_to_date str
    Date.parse(str).to_date
  end

  def datetime_to_date datetime
    datetime.to_date
  end

  def additional_info_for_current_date date
    if date.eql? Date.today
      'today'
    elsif date.eql? Date.today - 1
      'yesterday'
    elsif date.eql? Date.today + 1
      'tomorrow'
    elsif date < Date.today
      'past'
    else
      'future'
    end
  end

  def response_to_json msg
    respond_to do |format|
      format.json { render json: msg }
    end
  end


  def show_price price
    price.eql?(0) ? 0 : (price/1000).to_i.to_s + ',' + '000'
  end

  def show_price_integer price
    price.to_i
  end

  def display_price dish
    if dish.variants.blank?
      display_cost_as_thousand dish.price
    else
      list_price = dish.variants.map { |v| { v.size => display_cost_as_thousand(v.price) } }
      list_price.prepend dish.size => display_cost_as_thousand(dish.price)
    end
  end

  def today_order_display_name dish
    dish.name + (dish.size ? "[#{dish.size}]" : '')
  end

  def build_note_for_custom_salad components
    components.map { |k, v| "#{k}: #{v.map { |comp| DishedComponent.find_by(id: comp.first).name }.join(', ')} " }.join(". \n ")
  end

  def generate_custom_salad_name name
    name = 'Custom Salad -' + name
  end

  def helper_cal_total_price dishes
    dishes.inject(0) { |s, d| s += d.price }
  end

  def helper_dish_decorators dishes
    show_dishes = dishes.compact
    variants = show_dishes.map &:variants
    variants.delete_if &:blank?
    variants.flatten!
    variants.each{|v| show_dishes.delete(v)}
    show_dishes
  end

  def message_from_status(status)
    case status
      when Admin::ProvidersController::NO_MENU_STT
        'Add provider'
      when Admin::ProvidersController::NEED_TO_SET_PROVIDER_STT,
          Admin::ProvidersController::PENDING_STT
        'Add dishes'
      else
        ''
    end
  end

end

require 'rails_helper'

module FeatureHelpers
  ERROR_TITLE = 'WOOP, ERROR'
  NO_UPLOAD_FILE_MSG = 'No file chosen'
  ADMIN_EDIT_MENU_TITLE = '[Admin] Edit Menu'


  class PaginationWrapper
    attr_accessor :wrapper

    def initialize(element)
      @wrapper = element
    end

    def div
      divs[0]
    end

    def trs
      @wrapper.all('tr')
    end

    def divs
      @wrapper.all('div')
    end
  end

  def logged_as(user)
    page.set_rack_session(user_id: user.id)
    page.set_rack_session(is_admin: user.admin?)
  end

  def logged_as_admin
    admin = create(:user, admin: true)
    logged_as admin
  end

  #TODO: need metaprogramming
  def generate_invalid_restaurant_id
    Restaurant.last.id + 1
  end

  def generate_invalid_dish_id
    Dish.last.id + 1
  end

  def select_tag_include_options?(select, options)
    (select.all('options').collect(&:text) - options).empty?
  end

  def expect_page_show_error msg
    expect(page).to have_content FeatureHelpers::ERROR_TITLE
    expect(page).to have_content "Error message: #{msg}"
  end

  def clear_database
    tables = ['User', 'Dish', 'Restaurant', 'Menu', 'Order']
    tables.map {|t| eval("#{t}.destroy_all")}
  end

  def get_active_page wrapper
    wrapper.all('div')[0]
  end

  def wait_for_ajax(timeout = Capybara.default_max_wait_time)
    Timeout.timeout(timeout) do
      loop until page.evaluate_script('jQuery.active').try(:zero?)
    end
  end

  def select_date date, tag_name
    date_h = {'1' => date.year.to_s, '2' => Date::MONTHNAMES[date.month], '3' => date.day.to_s}
    date_h.map {|k, val| page.find("#{tag_name}#{k}i").select(val)}
  end

  def get_first_dish
    page.find('#order-new-wrap-dish-pagination').all('a')[0]
  end

  def convert_data_x_to_hash str
    eval(str.gsub('null', 'nil'))
  end

  def jpg_upload_file
    Rails.root + 'spec/files/BentoTaiwan.jpg'
  end

  def pdf_upload_file
    Rails.root + 'spec/files/EloRuby.pdf'
  end

  def generate_valid_name name
    res_name = Faker::Name.unique.name
    if res_name.eql? name
      Faker::Name.unique.name
    else
      res_name
    end
  end

  def wait_a_sec(seconds = 2)
    sleep seconds
  end

  def expec_show_img_as_binary
    expect(page.all('img')[0][:src][0, 21]).to match "data\:image\/jpg\;base64"
  end

  def expect_show_default_img
    expect(page.all('img')[0][:src][0, 34]).to match "/assets/default/default_restaurant"
  end

  def all_name_of collection
    collection.map(&:name)
  end

  def all_id_of collection
    collection.map(&:id)
  end

  def expect_field_have_value field, val
    expect(page.find_field(field).value).to eq val
  end
end

class Array
  def include_sub_array? sub_a
    (self & sub_a) == sub_a
  end
end


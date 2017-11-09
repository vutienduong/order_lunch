require 'rails_helper'

module FeatureHelpers
  ERROR_TITLE = 'WOOP, ERROR'
  NO_UPLOAD_FILE_MSG = 'No file chosen'
  ADMIN_EDIT_MENU_TITLE = '[Admin] Edit Menu'
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

  def expect_page_show_error page, msg
    expect(page).to have_content FeatureHelpers::ERROR_TITLE
    expect(page).to have_content "Error message: #{msg}"
  end
end
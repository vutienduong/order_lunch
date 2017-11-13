require 'spec_helper'

feature 'Create Restaurants', %q{
As an admin user
I want to create restaurant
} do
  Restaurant.destroy_all
  let!(:admin) {create(:user, admin: true)}
  let!(:restaurant) {create(:restaurant)}

  context 'click new button from all restaurants page' do
    before do
      logged_as_admin
      visit restaurants_path
      click_link 'New restaurant'
    end

    it 'should show new restaurant page' do
      expect(page).to have_current_path(new_admin_restaurant_path)
      expect(page).to have_content('New Restaurant')
      expect(page).to have_field 'restaurant[name]'
    end

    scenario 'leave restaurant name blank, then create' do
      click_button 'Create Restaurant'
      expect_page_show_error '{:name=>["can\'t be blank"]}'
    end

    scenario 'fill restaurant name by existed name previous' do
      fill_in 'Name', with: restaurant.name
      click_button 'Create Restaurant'
      error_msg = '{:name=>["has already been taken"]}'
      expect_page_show_error error_msg
    end

    describe 'fill in Restaurant Name field with a valid name' do
      before do
        @another_name  = generate_valid_name restaurant.name
        fill_in 'Name', with: @another_name
      end

      scenario 'fill name, leave address, phone, image_logo blank' do
        click_button 'Create Restaurant'
        expect(page).to have_current_path restaurant_path Restaurant.last
        expect(Restaurant.last.name).to eq @another_name
      end

      scenario 'upload image_logo with valid image file' do
        attach_file('restaurant[image_logo]', jpg_upload_file)
        click_button 'Create Restaurant'
        # expect(page).to have_selector 'img[src*=data\:image\/jpg\:base64]'
        # expect(page).to match have_xpath "//img[@src*=\"data:image/jpg;base64\"]"
        expec_show_img_as_binary
        expect(page).to have_content 'Restaurant details'
        expect(page).to have_content "Name: #{@another_name.upcase}"
      end

      scenario 'upload image_logo with pdf file' do
        attach_file('restaurant[image_logo]', pdf_upload_file)
        click_button 'Create Restaurant'
        expect(page).to have_selector('img', visible: true)
        expec_show_img_as_binary
      end
    end
  end
end
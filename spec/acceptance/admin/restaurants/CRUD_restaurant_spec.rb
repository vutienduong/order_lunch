require 'spec_helper'
feature 'New, Edit and Delete Restaurant', %q{
    As an admin,
I want to go to new form, edit or delete restaurant
} do
  Restaurant.destroy_all
  Dish.destroy_all
  let!(:admin) {create(:user, admin: true)}
  let!(:normal) {create(:user, admin: false)}
  let!(:restaurant) {create(:restaurant)}
  let!(:restaurant_2) {create(:restaurant)}

  let!(:dish) {create(:dish)}
  let!(:dish1) {create(:dish)}

  context 'log in as normal user' do
    before do
      logged_as normal
      restaurant.dishes.push(dish)
      restaurant.dishes.push(dish1)
    end

    scenario 'go to new restaurant page' do
      visit new_admin_restaurant_path
      expect(page).to have_current_path root_path
    end

    scenario 'go to edit page of an existed restaurant' do
      visit edit_admin_restaurant_path restaurant
      expect(page).to have_current_path root_path
    end

    scenario 'go to edit page of an non-exist restaurant' do
      visit edit_admin_restaurant_path restaurant.id + 100
      expect(page).to have_current_path root_path
    end

    describe 'go to all restaurant page' do
      before do
        visit restaurants_path
      end

      it 'should show restaurant name formed as link' do
        expect(page).to have_link restaurant.name, href: "/restaurants/#{restaurant.id}"
      end

      it 'should move to detail page when click to restaurant name', js: true do
        page.all('a', text: restaurant.name).first.click
        expect(page).to have_content 'Restaurant details'
        expect(page).to have_content restaurant.name.upcase
        expect(page).to have_content restaurant.dishes[0].name
      end

      it 'should active collapse effect when click to image logo of each restaurant', js: true do
        expect(page).not_to have_css '.panel-collapse'
        page.find_link(restaurant.name, href: "##{restaurant.id}_collapse").click
        wait_a_sec
        expect(page).to have_css '.panel-collapse'
        expect(page.all('.panel-collapse').first[:class]).to match 'panel-collapse collapse in'
      end

      describe 'open collapse list for a restaurant', js: true do
        it 'should show list dishes of that restaurant' do
          expect(page).not_to have_text restaurant.dishes[0].name
          page.find_link(restaurant.name, href: "##{restaurant.id}_collapse").click
          restaurant.dishes.each {|d| expect(page).to have_content d.name}
        end

        it 'should show nothing if that restaurant have no dishes', js: true do
          page.find_link(restaurant_2.name, href: "##{restaurant_2.id}_collapse").click
          expect(page.all('.panel-collapse').first.text()).to be_empty
        end
      end
    end
  end

  describe 'log in as admin user' do
    before do
      logged_as_admin
      restaurant.dishes.push(dish)
      restaurant.dishes.push(dish1)
    end

    context 'edit page' do
      before do
        visit edit_admin_restaurant_path restaurant
      end

      scenario 'go to edit restaurant page' do
        expect(page).to have_content 'EDIT RESTAURANT'
        expect(page).to have_field 'restaurant[name]'
        expect_field_have_value 'restaurant[name]', restaurant.name
        expect_field_have_value 'restaurant[address]', restaurant.address
        expect_field_have_value 'restaurant[phone]', restaurant.phone
        expect(page).to have_button 'Update Restaurant'
      end

      scenario 'delete name, leave blank and save' do
        fill_in 'restaurant[name]', with: ''
        click_button 'Update Restaurant'
        expect_page_show_error '{:name=>["can\'t be blank"]}'
      end

      scenario 'change name to same as an existed restaurant' do
        fill_in 'restaurant[name]', with: restaurant_2.name
        click_button 'Update Restaurant'
        expect_page_show_error '{:name=>["has already been taken"]}'
      end

      scenario 'upload another image logo' do
        attach_file('restaurant[image_logo]', jpg_upload_file)
        click_button 'Update Restaurant'
        expec_show_img_as_binary
        expect(page).to have_content 'Restaurant details'
        expect(page).to have_content "Name: #{restaurant.name.upcase}"
      end

      scenario 'no upload anything' do
        click_button 'Update Restaurant'
        expect_show_default_img
        expect(page).to have_content "Name: #{restaurant.name.upcase}"
      end

      scenario 'change phone number, address' do
        new_phone = Faker::PhoneNumber.phone_number
        new_address = Faker::Address.street_name
        fill_in 'restaurant[phone]', with: new_phone
        fill_in 'restaurant[address]', with: new_address
        click_button 'Update Restaurant'
        expect(page).to have_content "Phone: #{new_phone}"
        expect(page).to have_content "Address: #{new_address}"
      end
    end

    describe 'go to all restaurant page' do
      before do
        visit restaurants_path
      end

      it 'should show delete button for each dish', js:true do
        expect(page).not_to have_link 'Delete', href: admin_dish_path(restaurant.dishes[0].id)
        page.find_link(restaurant.name, href: "##{restaurant.id}_collapse").click
        wait_a_sec
        expect(page).to have_css '.panel-collapse'
        expect(page).to have_link 'Delete', href: admin_dish_path(restaurant.dishes[0].id)
      end

      describe 'click Delete button of a dish and confirm' do
        it 'should delete that dish and redirect to all restaurants page' do
          page.find_link(restaurant.name, href: "##{restaurant.id}_collapse").click
          wait_a_sec
          deleted_dish = restaurant.dishes[0]
          click_link 'Delete', href: admin_dish_path(deleted_dish.id)
          expect(Restaurant.find(restaurant.id).dishes.map(&:name)).not_to include deleted_dish.name
          expect(page).to have_current_path restaurants_path
        end
      end

    end

    describe 'click to delete' do
      before do
        visit restaurant_path restaurant
        click_link 'Delete'
      end
      it 'should delete restaurant from list restaurant' do
        expect(Restaurant.find_by(id: restaurant.id)).to be_nil
      end

      it 'should delete dishes belonged to deleted restaurant ?' do
        expect(all_id_of(Dish.all).include_sub_array? all_id_of restaurant.dishes).to eq false
      end
    end
  end
end
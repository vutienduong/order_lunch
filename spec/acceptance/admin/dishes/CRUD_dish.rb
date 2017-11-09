require 'acceptance/acceptance_helper'

feature 'CRUD Dish', %q{
As an admin,
I want to create, edit, delete dish
} do

  let!(:restaurant) {create(:restaurant)}

  let!(:restaurant2) {create(:restaurant)}
  let!(:order) {create(:order)}

  let!(:salmon) {create(:dish)}
  let!(:beef) {create(:dish)}

  context 'Create dish' do
    before do
      logged_as_admin
    end
    # test Dish model

    describe 'go to New Dish page' do
      before do
        visit restaurants_path
        page.find_link(restaurant.name, href: restaurants_path + '/' + restaurant.id.to_s).click
      end

      it 'should have New Dish and All restaurant buttons' do
        expect(page).to have_link 'New dish'
        expect(page).to have_link 'All Restaurants'
      end

      context 'create Dish in New Dish page' do
        before do
          click_link 'New dish'
        end
        it 'should error when click New Dish after fill, change nothing' do
          click_on 'Create Dish'
          expect(page).to have_content FeatureHelpers::ERROR_TITLE
          expect(page).to have_content 'Error message: {:name=>["can\'t be blank"]'
        end

        it 'should allow naming dish same as another but in different restaurant' do
          restaurant.dishes.push(salmon)
          fill_in 'Name', with: salmon.name
          click_on 'Create Dish'
          expect(page).to have_content FeatureHelpers::ERROR_TITLE
          expect(page).to have_content 'Error message: {:name=>["each restaurant doesn\'t have two dishes which are same named"]'
        end
      end
    end

    describe 'go to New Dish page by url with invalid Restaurant ID' do
      scenario 'without restaurant ID' do
        visit new_admin_dish_path
        expect(page).to have_content ErrorCode::ERR_NON_EXISTED_RESTAURANT[:msg]
      end

      scenario 'with restaurant ID not exist' do
        visit new_admin_dish_path + "?id=#{generate_invalid_restaurant_id}"
        expect(page).to have_content ErrorCode::ERR_NON_EXISTED_RESTAURANT[:msg]
      end
    end
  end

  context 'Edit dish' do
    before do
      logged_as_admin
    end

    scenario 'go to Edit Dish page by click Edit button' do
      visit dish_path salmon
      expect(page).to have_link 'Edit'
      click_link 'Edit'
      expect(page).to have_current_path edit_admin_dish_path salmon
    end

    scenario 'go to Edit Dish page by url' do
      visit edit_admin_dish_path salmon
      expect(page).to have_content("Restaurant: #{salmon.restaurant.name}")
    end

    scenario 'go to Edit Dish page with invalid Dish ID' do
      visit edit_admin_dish_path generate_invalid_dish_id
      expect(page).to have_content ErrorCode::ERR_NON_EXISTED_DISH[:msg]
    end

    it 'should show Image Upload section with nothing display (feature)' do
      #visit edit_admin_dish_path salmon
      #expect(page).to have_content FeatureHelpers::NO_UPLOAD_FILE_MSG
    end

    scenario 'Save without upload new image' do
      visit edit_admin_dish_path salmon
      fill_in 'Price', with: salmon.price + 1000
      click_button 'Update Dish'
      expect(page).to have_current_path dish_path salmon
    end
  end

end
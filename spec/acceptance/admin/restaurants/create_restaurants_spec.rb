require 'spec_helper'
require 'support/utilitize'

feature 'Create Restaurants', %q{
As an admin user
I want to create restaurant
} do
  let!(:admin) {create(:user, admin: true)}

  context 'click new button from all restaurants page' do
    before :each do
      logged_as admin
      visit restaurants_path
      click_button 'New restautant'
    end

    it 'should show new restaurant page' do
      expect(page).to have_current_path(new_admin_restaurant_path)
      expect(page).to have_content('New Restaurant')
    end

    scenario 'leave restaurant name blank, then create' do

    end

    scenario 'fill restaurant name by existed name previous' do

    end

    scenario 'fill name, leave address, phone, image_logo blank' do

    end

    scenario 'upload image_logo with valid image file' do

    end

    scenario 'upload image_logo with invalid image file' do

    end
  end
end
require 'spec_helper'
feature 'Manage Page', %q{
As an admin,
in order to manage Users, Menus, Restaurants,
I have privilege to access Manage page
} do

  include_context "shared stuff"
  before do
    logged_as_admin
    visit manage_admin_users_path
  end

  it 'should have three tabs for users, menus and restaurants', js: true do
    ['All Users', 'All Menus', 'All Restaurants'].each do |t|
      expect(page).to have_content t
    end
  end

  context 'All Users tab' do
    it 'should have same functions as [Admin] User Index page', js: true do
      click_button 'All Users'
      expect(page).to have_link 'New User'
      expect(page).to have_content user_1.email
      expect(page).to_not have_content (all_name_of menu.restaurants).join(' , ')
    end
  end

  context 'All Menus tab' do
    it 'should have same functions as [Admin] Menus Index page', js: true do
      click_button 'All Menus'
      expect(page).to have_link 'New Menu'
      expect(page).to_not have_link 'New User'
    end
  end

  context 'All Restaurants tab' do
    it 'should have same functions as [Admin] Restaurant Index page', js: true do
      click_button 'All Restaurants'
      expect(page).to have_link 'New restaurant'
      expect(page).to have_content restaurant_2.name
      expect(page).to_not have_content user_2.email
    end
  end
end
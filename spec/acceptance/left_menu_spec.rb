require 'acceptance/acceptance_helper'

feature 'Left menu (of functions) layout in left list', %q{
As a user
in order to use all function of app
I can see list of functions by group list in left menu
} do
  let!(:admin) {create(:user, admin: true)}
  let!(:normal_user) {create(:user, admin: false)}

  context 'log in as normal user' do
    before do
      logged_as normal_user
      visit root_path
    end
    it 'should have normal function' do
      expect(page).to have_link 'Order for today'
      expect(page).to have_link 'All orders today'
      expect(page).to have_link 'My orders history'
      expect(page).to have_link 'All Users'
      expect(page).to have_link 'All Restaurants'
      expect(page).to have_link 'All Menus'
    end
  end

  context 'log in as admin' do
    before do
      logged_as admin
      visit root_path
    end
    it 'should have functions for admin' do
      expect(page).to have_link 'MANAGE LUNCH TODAY'
      expect(page).to have_link 'MANAGE LUNCH ALL DAYS'
    end
  end

end
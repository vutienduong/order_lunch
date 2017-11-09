require 'acceptance/acceptance_helper'
require 'capybara'
require 'support/utilitize'

feature 'Login form', %q{
 As an user,
In order to see, modify app content,
I have to login
} do
  let!(:normal_user) {create(:user, admin: false)}
  let!(:admin) {create(:user, admin: true)}

  context 'sign me in' do
    before :each do
      visit login_path
    end

    scenario 'login correct password' do
      #session = Capybara::Session.new(:webkit)

      fill_login_form_with('//form', normal_user.email, normal_user.password)
      click_button 'Log in'
      expect(page).to have_current_path(user_path(normal_user))

      expect(page.get_rack_session_key('user_id')).to eq(normal_user.id)
      expect(page.get_rack_session_key('is_admin')).to eq(false)
    end

    scenario 'login incorrect combination email/password' do
      fill_login_form_with('//form', normal_user.email, normal_user.password + 'ax')
      click_button 'Log in'

      expect(page).to have_selector '.alert', text: 'Invalid email/password combination'
      expect(page).to have_current_path(login_path)
    end

    scenario 'login success as admin' do
      fill_login_form_with('//form', admin.email, admin.password)
      click_button 'Log in'

      expect(page).to have_link('Manager Page', href: manage_admin_users_path)
      expect(page).to have_link('MANAGE LUNCH TODAY', href: manage_company_admin_users_path)
      expect(page).to have_link('MANAGE LUNCH ALL DAYS', href: manage_all_days_admin_users_path)

      expect(page.get_rack_session_key('user_id')).to eq(admin.id)
      expect(page.get_rack_session_key('is_admin')).to eq(true)

    end
  end
end

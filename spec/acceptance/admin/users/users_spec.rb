require 'acceptance/acceptance_helper'
require 'support/utilitize'

feature 'Admin see users index', %q{
 As an admin
I want to see all users,
have permission to create new user, see edit, delete links
} do

  let!(:admin) {create(:user, admin: true)}
  let!(:normal_user) {create(:user, admin: false)}
  let!(:normal_user2) {create(:user, admin: false)}
  let (:new_pass) {2}


  context 'See list of users' do
    before :each do
      logged_as admin
      visit users_path
    end

    scenario 'see details of created users' do

      expect(page).to have_link('New User')
      all_tr= page.all("tr")

      within all_tr[1] do
        expect(page).to have_content(admin.username)
        expect(page).to have_content(admin.email)
        #within(:col, 3) {expect(page).to have_content(1)}
      end

      within all_tr[2] do
        expect(page).to have_content(normal_user.username)
        expect(page).to have_content(normal_user.email)
        #within(:col, 3) {expect(page).to have_content(0)}
      end
    end
    # expect is_admin?

    scenario 'should have edit, delete and details for each user' do
      expect(page).to have_link('Edit', href: edit_admin_user_path(normal_user))
      expect(page).to have_link('Delete', href: admin_user_path(normal_user))
      expect(page).to have_link('Details', href: admin_user_path(normal_user))
    end

    scenario 'able to click edit button to go to edit page' do
      page.first('a', :text => 'Edit') do |el|
        el.click
        expect(page).to have_text("[Admin] Edit User")
      end
      # TODO: should go to page with exact id of Edit button
      #first('div', '.btn btn-default dropdown-toggle').click
    end


    scenario 'click delete admin itself, expect can not delete itself' do
      page.first('a', text: 'Delete').click #TODO: need to check exactly a, then click
      expect(page).to have_content('Can\'t delete yourself with role as admin')
    end

    scenario 'click delete another user, expect successful, return list user with length reduced by 1' do
      old_len = User.all.length
      page.all('a', text: 'Delete')[1].click #TODO: hard code [1], need to fix
      expect(User.all.length).to equal(old_len-1)
      expect(page).to have_current_path(users_path)
    end
  end


  context 'See details of an user' do
    scenario 'login as admin' do
      logged_as admin
      visit users_path
      detail_td = page.all(:xpath, "//li/a[text()='Details']")
      detail_td[1].click

      expect(page).to have_content('[Admin] User Details')
      expect(page).to have_content(normal_user.username)
      expect(page).to have_content(normal_user.email)
      expect(page).to have_content('Is admin? No')

      expect(page).to have_link('Edit')
      expect(page).to have_link('Back to all users')
    end

    scenario 'login as normal user, see details of himself' do
      logged_as normal_user
      visit users_path
      page.all(:xpath, "//td/a[text()='Details']")[1].click
      expect(page).to have_link('Edit')
      page.find('a', text: 'Edit').click
      expect(page).to have_current_path(edit_user_path(normal_user))
    end

    scenario 'login as normal user, see details of another user' do
      logged_as normal_user
      visit users_path
      page.all(:xpath, "//td/a[text()='Details']")[0].click
      expect(page).to_not have_link('Edit')
    end
  end

  context 'Edit an user, log in as normal user' do
    before :each do
      logged_as normal_user
    end

    scenario 'try to edit profile of another user, by edit user link' do
      visit edit_user_path(normal_user2)
      expect(page).to have_current_path(edit_user_path (normal_user2))
      expect(page).to have_content('Error message: User doesn\'t have permission to edit this user')
    end

    scenario 'try to edit profile of another user, by admin edit user link' do
      visit edit_admin_user_path(normal_user2)
      expect(page).to have_current_path root_path
    end

    context 'edit itself' do
      it 'has username, email should be as unchangeable fields' do
        visit edit_user_path(normal_user)

      end

      # TODO: chua the check dc tru khi co confirm password
      it 'should not change password if password leave blank' do
        visit edit_user_path(normal_user)
        old_pass = User.find(normal_user.id).password_digest
        page.find('input[name=commit]').click
        expect(User.find(normal_user.id).password_digest).to eq(old_pass)
      end

      it 'should update password after save' do
        visit edit_user_path(normal_user)
        fill_in 'Password', with: new_pass
        #'input[name=user[password]]'
        click_button 'Update User'
        expect(page).to have_current_path user_path(normal_user)
        save_and_open_page

        expect(User.find(normal_user.id).authenticate(new_pass)).to eq(normal_user)
      end
    end
  end

  context 'edit an user, log in as admin user' do
    before :each do
      logged_as admin
      visit edit_admin_user_path(normal_user)
      find(:css, "#user_admin[value='1']").set(true)
    end

    scenario 'should have is admin = 1 after check as admin and submit' do
      click_button 'Update User'
      expect(User.find(normal_user.id).admin?).to equal(true)
    end

    scenario 'nothing change after click cancel' do
      fill_in 'Password', with: new_pass
      click_link 'Back'
      expect(User.find(normal_user.id).admin?).to equal(false)

      expect(User.find(normal_user.id).authenticate(new_pass)).to be_falsey
    end
  end


end
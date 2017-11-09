require 'acceptance/acceptance_helper'
require 'support/utilitize'

feature 'Create Edit Order', %q{'As a user
in order to add dishes. edit note
} do
  let!(:admin) {create(:user, admin: true)}
  let!(:normal_user) {create(:user, admin: false)}

  context 'first time login in current day, or first time go to order page in that day' do

    before :each do
      logged_as normal_user
      click_link 'Order for today'
    end

    it 'create new order for current user, with no dish, note nil' do

    end

    scenario 'see list dishes in 3 tabs' do

    end

    it 'should have no dish in list today dish in right side' do

    end

    it 'should display total price equal 0' do

    end

    it 'should display note nil' do

    end

  end

  context 'no menu for current day' do
    before :each do
      logged_as normal_user
      click_link 'Order for today'
    end

    it 'should show no menu for today and request admin for menu when user go to order page' do

    end
  end

  context 'tab all Restaurants' do
    describe 'click to a restaurant' do
      it 'should move to restaurant page' do

      end

      it 'should have list of dishes' do

      end

      it 'should have no dishes if that restaurant has no dishes' do

      end

      it 'should have \'Add\' button for each dish, and it is clickable' do

      end
    end
  end

  context 'tab all dishes' do
    it 'should have all dishes from all restaurants for that day' do

    end

    it 'should show Plus button to add dish for order' do

    end

    describe 'add dish by click to Plus button' do
      it 'should call ajax to add to order of login user' do

      end

      it 'should update total cost of order' do

      end

      it 'should warning if total cost is over budget' do

      end

      it 'should change color of total cost if budget over' do

      end

      it 'should show error (or do nothing) if dish is deleted' do

      end

      it 'should update DishOrder table' do

      end

      it 'should add to Today order' do

      end

    end

    describe 'add a dish many time' do
      it 'should allow this' do

      end

      it 'should add corresponding number of records to DishOrder table' do

      end

    end
  end

  context 'tab All Orders' do
    it 'should show orders of all users' do

    end

    it 'should show copy button for all users, expect current user' do

    end

    it 'should highlight order of current user' do

    end

    it 'should highlight cost which over budget' do

    end

    describe 'user choose dish from tab All dishes' do
      it 'should not show up-to-date dishes (this is feature)' do

      end

      it 'update orders for all users after refresh page' do

      end
    end

    describe 'current user click to copy button of another user' do
      it 'should show same dishes as copied user' do

      end
    end
  end

  context 'Today order' do
    describe 'remove dish' do
      it 'should call ajax to remove from OrderDish' do

      end

      it 'should update total cost' do

      end

      it 'should update Over Budget warning' do

      end
    end

    describe 'edit Note' do
      it 'should show Modal when click to Edit button' do

      end

      describe 'change Note content in Modal and click Save' do
        it 'should call ajax to update Note for that order' do

        end

        it 'notice Success on UI' do

        end

        it 'notice Fail if ajax fail on UI' do

        end
      end
    end
  end
end
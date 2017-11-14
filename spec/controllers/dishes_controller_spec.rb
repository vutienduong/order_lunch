require 'rails_helper'
describe Admin::DishesController do
  describe 'DELETE destroy' do
    before :each do
      @dish = create(:dish)
      @dish2 = Dish.last
    end

    it 'delete dummy dish' do
      expect {
        delete :destroy, id: @dish
      }.to change(Dish, :count).by(0)
    end

    it 'delete real dish' do
      p 'real dish: #{@dish2.inspect}'
      expect {
        delete :destroy, id: @dish
      }.to change(Dish, :count).by(0)
    end

    it 'redirects to dishes#index' do
      delete :destroy, id: @dish
      expect(response).to redirect_to root_path
    end

  end
end

describe 'Public access to list dishes', type: :request do
  it 'denies access to dish#new' do
    get new_admin_dish_path
    expect(response).to redirect_to root_path
  end

  it 'denies access to dishes#create' do
    dish_attrs = FactoryBot.attributes_for(:dish)
    expect {
      post '/admin/dishes/', {dish: dish_attrs}
    }.to_not change(Dish, :count)

    expect(response).to redirect_to root_path
  end
end

feature 'Access user index page', type: :feature do
  scenario 'User see a user profile', js: true do
    fish = FactoryBot.create(:dish)
    alan = FactoryBot.create(:user, admin: true, username: 'Alan smith')
    smith = FactoryBot.create(:user, admin: false)

    p 'alan name: #{alan.username}'

    visit root_path

    expect(page).to have_content alan.username

    expect(page).to_not have_link 'New User'

    click_link 'Details', href: user_path(alan.id)
    expect(page).to have_content 'Alan smith'

    click_link 'Back to all users'

    expect(current_path).to eq users_path

    within 'h1' do
      expect(page).to have_content 'List Users'
    end
  end
end
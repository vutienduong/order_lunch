require 'spec_helper'
feature 'Restaurant Detail Page', %q{
As an admin,
I want to edit, delete restaurant via detail page
} do
  Restaurant.destroy_all
  Dish.destroy_all
  let!(:restaurant) {create(:restaurant)}
  let!(:restaurant_2) {create(:restaurant)}

  let!(:dish) {create(:dish)}
  let!(:dish1) {create(:dish)}

  before do
    logged_as_admin
    restaurant.dishes.push(dish)
    restaurant.dishes.push(dish1)
    visit restaurant_path restaurant
  end

  it 'should show group button for CRUD restaurant', js: true do
    expect(page).to have_selector 'button#_amend_button_group'
    expect(page).to_not have_link 'Edit'
  end

  it 'should show restaurant details' do
    expect(page).to have_content 'Restaurant details'
  end

  it 'should show dishes of that restaurant as links' do
    dishes = restaurant.dishes
    expect(page).to have_link dishes[0].name, href: dish_path(dishes[0])
    expect(page).to have_link dishes[1].name, href: dish_path(dishes[1])
  end

  it 'should show All Restaurants button' do
    expect(page).to have_link 'All Restaurants'
  end

  it 'should move to All Restaurants page after click to All Restaurant button' do
    page.all('a.btn', text: 'All Restaurants').first.click
    expect(page).to have_current_path restaurants_path
    expect(page).to have_content 'All Restaurants'
  end

  it 'should redirect to dish detail page when click to dish name' do
    selected_dish = restaurant.dishes[0]
    click_link selected_dish.name
    expect(page).to have_current_path dish_path selected_dish
    expect(page).to have_content 'DISH DETAIL'
  end

  describe 'click to group button in top left', js: true do
    before do
      page.find('button#_amend_button_group').click
    end

    it 'should show Edit, Delete and New Dish buttons' do
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
      expect(page).to have_link 'New dish'
    end

    it 'should redirect to Edit page when click to Edit button' do
      click_link 'Edit'
      expect(page).to have_current_path edit_admin_restaurant_path restaurant
      expect(page).to have_button 'Update Restaurant'
    end

    it 'should redirect All Restaurants page when click to Delete button' do
      click_link 'Delete'
      expect(page).to have_current_path restaurants_path
      expect(Restaurant.find_by(id: restaurant.id)).to be_nil
    end

    it 'should redirect to New Dish page when click to New Dish button' do
      click_link 'New dish'
      expect(page).to have_current_path new_admin_dish_path({id: restaurant.id})
      expect(page).to have_button 'Create Dish'
    end
  end
end
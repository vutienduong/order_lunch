require 'spec_helper'
feature '[Admin] All orders today', %q{
As an admin,
in order to see all order today, create new order and edit existed order,
I have privilege to access All orders page
} do

  let! (:user_1) {create(:user)}
  let! (:user_2) {create(:user)}

  let! (:restaurant_1) {create(:restaurant)}
  let! (:restaurant_2) {create(:restaurant)}

  let! (:menu) {create(:menu, date: Date.today, restaurants: [restaurant_1, restaurant_2])}

  let! (:order_1) {create(:order, date: Date.today, user: user_1, dishes: restaurant_1.dishes)}
  let! (:order_2) {create(:order, date: Date.today, user: user_2, dishes: restaurant_2.dishes)}

  before do
    logged_as_admin
    visit get_all_orders_today_users_path
  end

  # TODO: it should have all tests of all_orders_page for normal user
  it 'should have New orders button' do
    expect(page).to have_link 'New orders'
  end

  it 'should move to New Order page when click to New Order button' do
    click_link 'New orders'
    expect(page).to have_current_path new_admin_order_path
    expect(page).to have_button 'Create Order'
  end

  it 'should display order ID under link form' do
    ['1', '2'].each do |i|
      eval("expect(page).to have_link order_#{i}.id.to_s, href: admin_order_path(order_#{i})")
    end
  end

  it 'should move to order page when click to Order ID' do
    click_link order_1.id.to_s, href: admin_order_path(order_1)
    expect(page).to have_content 'Order Details'
    expect(page).to have_content order_1.user.username
    expect(page).to have_content all_name_of(order_1.dishes).join(' , ')
  end
end
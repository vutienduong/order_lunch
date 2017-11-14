require 'spec_helper'
feature 'All orders today', %q{
As an user,
in order to see all order today,
I have privilege to access All orders page
} do
  include_context 'shared stuff'

  #TODO: these tests also are used to All_Orders tab in Order page
  before do
    logged_as user_1
    set_today_order_id order_1.id
    visit get_all_orders_today_users_path
    @today_orders = Order.where("DATE(date)=?", Date.today)
    @first_order = @today_orders.first
  end
  it 'should show list of orders of all users today' do
    table = page.all('table')[0]
    tr = table.all('tr')[0]
    vals = ['Order ID',	'User',	'Dishes',	'Totals',	'Note',	'Action']
    check_content_each_td tr, vals, 'th'

    tr = table.all('tr')[1]
    @first_order = @today_orders.first
    vals = [].push(@first_order.id)
               .push(@first_order.user.username)
               .push(all_name_of(@first_order.dishes).join(' + '))
               .push(@first_order.dishes.inject(0){|s,v| s+= v.price}.to_s)
    check_content_each_td tr, vals
  end

  it 'should display order ID under non-link form' do
    expect(page).to_not have_link @first_order.id.to_s, href: admin_order_path(@first_order)
  end

  it 'should display Copy button for users except current user', js: true do
    expect(page.all('td a').length).to eq 1
  end

  it 'can be copy order of other user by click Copy button and move to Order page', js: true do
    page.all('td a').first.click
    wait_for_ajax
    expect(Order.find_by(id: order_1.id).dishes).to eq order_2.dishes
    #expect(page).to have_current_path order_user_path
  end
end




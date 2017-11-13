require 'spec_helper'
include ApplicationHelper
feature 'Manage Lunch Page', %q{
As an admin,
in order to manage orders, dishes by date,
I have privilege to access Manage Luch (today/all day) page
} do

  include_context "shared stuff"

  before do
    logged_as_admin
    visit manage_company_admin_users_path

    @today_orders = Order.where("DATE(date)=?", Date.today)
    all_dishes = @today_orders.map {|t| t.dishes}
    all_dishes = all_dishes.flatten

    @counted_dishes = Hash.new(0).tap {|h| all_dishes.each {|dish| h[dish] += 1}}
    @counted_dishes.delete_if {|k, v| k.id.nil?}
  end

  it 'should have list of orders' do
    expect(page).to have_content 'List of orders'
    first_order = @today_orders.first
    table = page.all('table')[0]
    tr = table.all('tr')[1]
    within tr do
      tds = page.all('td')
      expect(tds[0]).to have_content first_order.id
      expect(tds[1]).to have_content first_order.user.username
      expect(tds[2]).to have_content all_name_of(first_order.dishes).join(' , ')
      expect(tds[3]).to have_content displayCostAsThousand first_order.dishes.inject(0) {|s, d| s+d.price}
    end
  end

  it 'should have list of dishes' do
    expect(page).to have_content 'List of dishes'
    table = page.all('table')[1]
    tr = table.all('tr')[1]

    first_dish = @counted_dishes.first
    count_first_dish = first_dish.last
    first_dish = first_dish.first
    within tr do
      tds = page.all('td')
      expect(tds[0]).to have_content first_dish.name
      expect(tds[1]).to have_content first_dish.restaurant.name
      expect(tds[2]).to have_content count_first_dish
      expect(tds[3]).to have_content displayCostAsThousand(first_dish.price * count_first_dish)
    end
  end

  it 'should have list of costs' do
    expect(page).to have_content 'List of costs'
  end

  context 'manage all days' do
    it 'should have select date part' do

    end

    it 'should update list of orders, dishes, costs when select date' do

    end

    it 'should allow date without menu show nil orders, dishes and costs' do

    end
  end

end
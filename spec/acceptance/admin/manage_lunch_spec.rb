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
  end

  context 'manage resouce today' do
    before do
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
      vals = [].push(first_order.id)
                 .push(first_order.user.username)
                 .push(all_name_of(first_order.dishes).join(' , '))
                 .push(displayCostAsThousand(first_order.dishes.inject(0) {|s, d| s + d.price}))

      check_content_each_td tr, vals
    end

    it 'should have list of dishes' do
      expect(page).to have_content 'List of dishes'
      table = page.all('table')[1]
      tr = table.all('tr')[1]

      first_dish = @counted_dishes.first
      count_first_dish = first_dish.last
      first_dish = first_dish.first
      vals = [].push(first_dish.name)
                 .push(first_dish.restaurant.name)
                 .push(count_first_dish)
                 .push(displayCostAsThousand(first_dish.price * count_first_dish))
    end

    it 'should have list of costs' do
      expect(page).to have_content 'List of costs'
      all_costs = {}
      @counted_dishes.each do |dish, count|
        restaurant = dish.restaurant
        if !all_costs.has_key? restaurant
          all_costs[restaurant] = {}
          all_costs[restaurant][:dishes] = {dish => {count: count, cost: dish.price * count}}
          all_costs[restaurant][:cost] = dish.price * count
        else
          all_costs[restaurant][:dishes][dish] = {count: count, cost: dish.price * count}
          all_costs[restaurant][:cost] += dish.price * count
        end
      end

      first_restaurant = all_costs.first
      belonged_dishes = first_restaurant.last[:dishes]
      cost = first_restaurant.last[:cost]
      first_restaurant = first_restaurant.first

      table = page.all('table')[2]
      tr = table.all('tr')[1]
      vals = [].push(first_restaurant.name)
                 .push(first_restaurant.phone)
                 .push(displayCostAsThousand(cost))

      check_content_each_td tr, vals

      dish_idx = 2
      belonged_dishes.each do |dish_h|
        tr = table.all('tr')[dish_idx]
        vals = [].push('')
                   .push(dish_h.first.name)
                   .push("(#{dish_h.last[:count].to_s})")
                   .push(displayCostAsThousand dish_h.last[:cost])
        check_content_each_td tr, vals
        dish_idx += 1
      end

    end
  end

  context 'manage all days' do
    before do
      visit manage_all_days_admin_users_path
    end

    it 'should have select date part' do
      expect(page).to have_selector 'select#order_date_1i'
      expect(page).to have_button 'See'
    end

    it 'should update list of orders, dishes, costs when select date' do
      order = Order.create(date: Date.today - 1, user: user_1, dishes: [dish_11, dish_12])
      select_date Date.today - 1, 'select#order_date_'
      click_button 'See'
      expect(page).to have_content Date.today - 1
      expect(page).to have_content dish_11.name
      expect(page).to have_content dish_12.name
    end

    it 'should allow date without menu show nil orders, dishes and costs' do
      select_date Date.today - 1, 'select#order_date_'
      click_button 'See'
      expect(page).to have_content Date.today - 1
      expect(page.all('table')[0].all('tr').length).to eq 1
      expect(page.all('table')[1].all('tr').length).to eq 1
      expect(page.all('table')[2].all('tr').length).to eq 3
    end
  end

end
require 'spec_helper'
feature '[Admin] My order history', %q{
As an user,
I want to see my order history through all days,
I have privilege to access My order history page
} do
  include_context 'shared stuff'
  before do
    logged_as user_1
    order_3 = Order.create(dishes: [dish_11, dish_12], user: user_1, date: Date.today - 2)
    order_3.save
    visit orders_show_personal_orders_path
  end
  it 'should show list of my orders day-by-day' do
    orders = Order.where('user_id = ?', user_1.id)
    row_idx = 1
    table = page.all('table')[0]
    orders.each do |o|
      tr = table.all('tr')[row_idx]
      vals = [].push(o.date)
      .push(all_name_of(o.dishes).join(' + '))
      .push(o.note)
      check_content_each_td tr, vals
      row_idx += 1
    end
  end
end




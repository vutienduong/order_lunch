require 'acceptance/acceptance_helper'

feature 'Handle Order', %q{
As an admin,
I want to add new order,
delete order for other users
} do

  Menu.destroy_all
  Order.destroy_all
  Restaurant.destroy_all
  Dish.destroy_all
  User.destroy_all

  let! (:user1) {create(:user)}
  let! (:user2) {create(:user, email: 'richard.max@gmail.com')}
  let! (:user3) {create(:user, email: 'will.richard.101@yahoo.com')}
  let! (:user4) {create(:user, email: 'richad.halo@naver.com')}

  (1..4).each do |n|
    let! (("order_#{n}").to_sym) {create(:order)}
  end

  (1..3).each do |n|
    let! (("restaurant_#{n}").to_sym) {create(:restaurant)}
  end

  (1..3).each do |i|
    (1..3).each do |j|
      let! (("dish_#{i}_#{j}").to_sym) {create(:dish)}
    end
  end

  let! (:today_menu) {create(:menu, date: Date.today)}
  let! (:yesterday_menu) {create(:menu, date: Date.today - 1.day)}
  let! (:keyword) {'richard'}
  let! (:another_keyword) {'neveremploymenthero.com'}

  # @today  = Date.today
  # @yesterday = Date.today - 1
  # @another_day = Date.today - 10
  # YESTERDAY = {'1'=>@yesterday.year.to_s, '2'=>Date::MONTHNAMES[@yesterday.month], '3' => @yesterday.day.to_s}
  # ANOTHERDAY = {'1'=>@another_day.year.to_s, '2'=>Date::MONTHNAMES[@another_day.month], '3' => @another_day.day.to_s}

  describe 'login first' do
    before do
      (1..3).each do |i|
        (1..3).each do |j|
          eval("restaurant_#{i}.dishes.push(dish_#{i}_#{j})")
        end
      end

      (1..3).each do |i|
        eval("today_menu.restaurants.push(restaurant_#{i})")
      end

      yesterday_menu.restaurants.push(restaurant_1)
      logged_as_admin
    end

    context 'New Order', js: true do
      before do
        visit get_all_orders_today_users_path
        click_link 'New orders'
        @left_list = page.find('#order-new-wrap-dish-pagination')
        @right_list = page.find('#order-new-wrap-list-dish')
      end

      describe 'Go to [Admin] new order page' do
        it 'should show all dishes under pagination from' do
          (0..2).each do |n|
            eval("expect(page).to have_content dish_#{n/3 + 1}_#{n%3 + 1}.name")
          end

          expect(page).to_not have_content dish_2_1.name
        end

        it 'should have pagination with exact functions' do
          expect(page).to have_css('div#order-new-wrap-dish-pagination')

          # check page with href and class
          ('1'..'5').each do |page_num|
            expect(page).to have_link(page_num, :href => '#')
            within page.find_link(page_num, href: '#') do
              expected_class = page_num == '1' ? 'page active' : 'page' # page 1 active
              expect(page.find(:xpath, '..')[:class]).to eq(expected_class)
            end
          end

          # check First, Prev, Next, Last
          {'First' => 'first disabled', 'Previous' => 'prev disabled', 'Next' => 'next', 'Last' => 'last'}.each do |text, class_name|
            expect(page).to have_link(text, href: '#')
            within page.find_link(text, href: '#') do
              expect(page.find(:xpath, '..')[:class]).to eq(class_name)
            end
          end

          wrapper = @left_list
          wrapper_i = FeatureHelpers::PaginationWrapper.new(wrapper)

          # check each page have 3 dishes
          expect(wrapper_i.trs.length).to eq(3)

          dishes = today_menu.restaurants.map {|r| r.dishes}.flatten
          num_dishes = today_menu.restaurants.inject(0) {|n, r| n + r.dishes.length}
          last_page_idx = (num_dishes.to_f/3).ceil

          # current active page is page 1
          active_page = wrapper_i.div
          expect(active_page[:id]).to eq('dish-page-1')
          expect(active_page[:class]).to eq('page page-active')
          expect(wrapper).to have_text(dishes[0].name)

          click_link '2' #go to page 2
          active_page = wrapper_i.div
          expect(active_page[:id]).to eq('dish-page-2')
          expect(active_page[:class]).to eq('page page-active')
          expect(wrapper).to have_text(dishes[3].name)
          expect(wrapper).to_not have_text(dishes[0].name)

          click_link 'First' #First, go back to page 1
          expect(wrapper_i.div[:id]).to eq('dish-page-1')
          expect(wrapper).to have_text(dishes[0].name)

          click_link 'Last' #go to page 5
          expect(wrapper.all('tr')).to be_empty

          click_link last_page_idx.to_s if last_page_idx <= 5 #go to last page with data, here, page 3
          expect(wrapper).to have_text(dishes[(last_page_idx-1)*3].name)

          click_link 'Previous' #go to page 2
          expect(wrapper_i.div[:id]).to eq('dish-page-2')
        end
      end

      context 'Find user', js: true do
        it 'should call ajax after 2 sec delay with user\'s key up' do
          expect(page).to have_field 'order[user]'
          within 'form#new_order' do
            fill_in 'order[user]', with: keyword
            sleep(1)
            expect(page).to_not have_link user2.email
            sleep(3)
            wait_for_ajax
            within 'div#order-new-user-result' do
              expect(page).to have_link user2.email
              expect(page).to have_link user3.email
              expect(page).not_to have_link user1.email
            end

            fill_in 'order[user]', with: another_keyword
            sleep(5)
            wait_for_ajax
            within 'div#order-new-user-result' do
              expect(page.all('.list-group-item')).to be_empty
            end
          end
        end

        it 'should fill user email to input field if click to user link' do
          fill_in 'order[user]', with: keyword
          sleep(4)
          wait_for_ajax
          within 'div#order-new-user-result' do
            expect(page).to have_link user2.email
            click_link(user2.email, match: :first)
          end
        end

      end

      context 'Change date' do
        it 'should show dishes correspond to menu of selected date' do
          select_date Date.today - 1, 'select#order_date_'
          first_dish = yesterday_menu.restaurants.map {|r| r.dishes}.flatten.first.name
          click_link 'select', href: '#'
          wait_for_ajax
          expect(@left_list.all('div')[0]).to have_text(first_dish)
        end

        it 'should no dish if that date have no menu' do
          select_date Date.today - 10, 'select#order_date_'
          click_link 'select', href: '#'
          expect(@left_list.all('tr')).to be_empty
        end
      end

      context 'Select dish' do
        describe 'Click Add button' do
          before do
            first_dish = get_first_dish
            first_dish.click
            @sel_dish_data = convert_data_x_to_hash first_dish['data-dish']
            @total_price = page.find('#order-new-total-price')
          end
          it 'should add that dish to List Dishes' do
            expect(@right_list.all('tr').length).to eq(1)
            within @right_list.all('tr').first do
              expect(page).to have_content(@sel_dish_data[:name])
              expect(page).to have_link('remove')
            end
          end

          it 'should update total' do
            expect(@total_price.text().to_f).to eq @sel_dish_data[:price].to_f
          end

          scenario 'click remove, it should remove that dish from Chosen List' do
            removed_item = @right_list.all('tr').first.find('a').click
            expect(@total_price.text().to_f).to eq(0.0)
          end
        end
      end

      context 'Delete Order' do
        before do
          visit admin_order_path order_1
        end

        it 'should delete that order from Order table and DishOrder table' do
          expect(page).to have_link 'Delete'
          click_link 'Delete'
          expect(Order.find_by_id(order_1.id)).to be_nil
          expect(DishOrder.find_by_order_id(order_1.id)).to be_nil
        end
      end
    end
  end
end
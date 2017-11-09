require 'acceptance/acceptance_helper'

feature 'CRUD menu', %q{
As an admin,
I want to see all menus, and create, edit, delete menu
} do

  Menu.destroy_all
  Restaurant.destroy_all

  let! (:restaurant_Mania) {create(:restaurant)}
  let! (:restaurant_Sword) {create(:restaurant)}
  let! (:restaurant_Shell) {create(:restaurant)}

  let! (:menu_Monday) {create(:menu, date: Date.today - 1)}
  let! (:menu_Tuesday) {create(:menu, date: Date.today)}

  (1..4).each do |n|
    let! (("menu_#{n}").to_sym) {create(:menu, date: Date.today - n - 3)}
  end

  let! (:postfixes) {[(1..4), ['Monday', 'Tuesday']]}

  EXAMPLE_DATE = {'1'=>'2015', '2'=>Date::MONTHNAMES[11], '3' => '11'}

  describe 'login first' do
    before do
      logged_as_admin

      menu_Monday.restaurants.push(restaurant_Mania)
      menu_Monday.restaurants.push(restaurant_Sword)

      menu_Tuesday.restaurants.push(restaurant_Shell)
      menu_Tuesday.restaurants.push(restaurant_Sword)

      puts '*'*100
      puts Menu.find_by(date: Date.today - 1).restaurants.count
    end

    context 'All menu' do
      before do
        visit menus_path
      end

      it 'should show all menus, each day has one menu' do
        postfixes.each do |a|
          a.each do |n|
            expect(page).to have_content(eval("menu_#{n}").date, count: 1)
          end
        end
      end

      it 'should show all selected restaurant for each menu' do
        postfixes.each do |a|
          a.each do |n|
            expect(page).to have_content(eval("menu_#{n}").restaurants.map(&:name).join(' , '))
          end
        end

        expect(page).to have_content(menu_Monday.restaurants.map(&:name).join(' , '))
        expect(page).to have_content(menu_Tuesday.restaurants.map(&:name).join(' , '))
      end

      it 'should show Edit, Delete buttons for each menu' do
        within page.all('tr')[1] do
          expect(page).to have_link 'Edit'
          expect(page).to have_link 'Delete'
        end
      end

      it 'should show New Menu button' do
        expect(page).to have_link 'New Menu'
      end

      scenario 'click Edit button and move to Edit page' do
        temp_menu = menu_1
        page.find_link('Edit', href: edit_admin_menu_path(temp_menu)).click
        expect(page).to have_content(FeatureHelpers::ADMIN_EDIT_MENU_TITLE)
        expect(page).to have_content(temp_menu.date.strftime('%Y-%m-%d'))
      end

      describe 'click Delete button to delete a menu' do
        before do
          visit menus_path
          @before_length = Menu.all.length
          within page.all('tr')[2] do
            click_link 'Delete'
          end
        end

        it 'should delete selected menu' do
          expect(Menu.all.length).to eq(@before_length-1)
        end

        it 'should redirect to all menus page' do
          expect(page).to have_current_path menus_path
        end
      end
    end

    context 'New page' do
      before do
        visit menus_path
        click_link 'New Menu'
        @add_button = page.find('a#new-menu-push')
        @remove_button = page.find('a#new-menu-pop')
        @left_list = page.find('select#new-menu-all-restaurants')
        @right_list = page.find('select#menu_restaurant_ids')
      end

      it 'should show all restaurants available in left-hand list' do
        list_ops = @left_list.all('option').collect(&:text)
        dummy_op = list_ops.shift

        all_restaurants = Restaurant.all.map(&:name)
        expect(list_ops-all_restaurants).to be_empty
        expect(list_ops.length).to eq(all_restaurants.length)
        expect(dummy_op).to include('Select Restaurant')
      end

      describe 'click Add button if' do
        scenario 'in left list, choose no restaurant', js: true do
          @add_button.click
          expect(@right_list.all('option')).to be_empty
        end

        scenario 'in left list, choose some restaurants, some of them same as selected restaurants in right list', js: true do
          selected_restaurants = Restaurant.first(3)
          selected_ops = selected_restaurants.map(&:name)
          selected_ops.each do |s|
            @left_list.select(s, match: :first)
          end
          @add_button.click

          @left_list.select(selected_ops[0], match: :first)
          @add_button.click

          expect(select_tag_include_options?(@right_list, selected_ops)).to eq(true)
        end
      end

      describe 'click Remove button if' do
        scenario 'in right list, choose no restaurant', js: true do
          expect(@right_list.all('option').collect(&:text)).to be_empty
          @remove_button.click
          expect(@right_list.all('option').collect(&:text)).to be_empty
        end

        scenario 'in right list, choose some restaurants', js: true do
          selected_restaurants = Restaurant.first(3)
          selected_ops = selected_restaurants.map(&:name)
          selected_ops.map {|s| @left_list.select(s, match: :first)}
          @add_button.click

          keep_op = selected_ops.shift
          selected_ops.map {|s| @right_list.select(s, match: :first)}
          @remove_button.click

          expect(@right_list.all('option').map(&:text).join()).to eq(keep_op)
        end
      end

      scenario 'select a specified date, click Create Menu', js: true do
        EXAMPLE_DATE.map {|k, val| page.find("select#menu_date_#{k}i").select(val)}
        click_button 'Create Menu'
        expect_page_show_error page, '{:restaurants=>["can\'t be blank"]'
      end

      describe 'create menu without select date' do
        scenario 'with some selected restaurants' , js: true do
          EXAMPLE_DATE.map {|k, val| page.find("select#menu_date_#{k}i").select(val)}
          date = page.all("select[id^=\menu_date_\]").map(&:value).join('-')

          selected_restaurants = Restaurant.first(3)
          selected_ops = selected_restaurants.map(&:name)
          selected_ops.each {|s| @left_list.select(s, match: :first)}
          @add_button.click
          click_button 'Create Menu'
          expect(page).to have_current_path(menu_path Menu.last)
          expect(page).to have_content(date)

          selected_ops.each {|s| expect(page).to have_content(s)}
          expect(Menu.last.restaurants.map(&:name)).to eq selected_ops
        end

        scenario 'with no restaurant' do
          click_button 'Create Menu'
          expect_page_show_error page, '{:restaurants=>["can\'t be blank"]'
        end
      end
    end

    context 'Edit page' do
      before do
        visit menus_path
        page.find_link('Edit', href: edit_admin_menu_path(menu_1)).click
        @remove_button = page.find('a#new-menu-pop')
        @right_list = page.find('select#menu_restaurant_ids')
      end

      it 'should show restaurants of that menu in right list' do
        expect(@right_list.all('option').collect(&:value).map{|i| i.to_i} - menu_1.restaurants.collect(&:id)).to be_empty
        expect(select_tag_include_options?(@right_list, menu_1.restaurants.collect(&:name))).to equal(true)
      end

      scenario 'save menu after remove all restaurants in right list', js: true do
        @right_list.all('option').select
        @remove_button.click
        expect(@right_list.all('option')).to be_empty
        click_button 'Update Menu'
        expect_page_show_error page, '{:restaurants=>["can\'t be blank"]}'
      end
    end

    context 'Menu details' do
      before do
        @menu = menu_1
        visit menu_path @menu
      end

      it 'should show all restaurants of menu' do
        @menu.restaurants.map(&:name).each {|r| expect(page).to have_content r}
      end

      it 'should show date of menu' do
        expect(page).to have_content(@menu.date)
      end

      it 'should show restaurant name as link' do
        @menu.restaurants.map {|r| [r.id, r.name]}.to_h.each do |id, name|
          expect(page).to have_link(name, href: restaurant_path(id))
        end
      end

      it 'should move to Restaurant detail page when click to restaurant name' do
        res1 = @menu.restaurants[0]
        page.find_link(res1.name).click
        expect(page).to have_content 'Restaurant details'
      end
    end

    context 'Delete menu' do
      before do
        visit menus_path
      end

      scenario 'delete a menu by Delete link' do
        num_menu = Menu.all.length
        page.all('a', text: 'Delete')[0].click
        expect(page).to have_current_path menus_path
        expect(Menu.all.length).to eq(num_menu - 1)
      end

    end
  end
end
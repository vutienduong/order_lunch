feature 'CRUD menu', %q{
As an admin,
I want to see all menus, and create, edit, delete menu
} do

  context 'All menu' do
    before do
      visit menus_path
    end

    it 'should show all menus, each day has one menu' do

    end

    it 'should show all selected restaurant for each menu' do

    end

    it 'should show Edit, Delete buttons for each menu' do

    end

    it 'should show New Menu button' do

    end

    scenario 'click Edit button and move to Edit page' do

    end

    describe 'click Delete button to delete a menu' do
      before do

      end

      it 'should delete selected menu' do

      end

      it 'should redirect to all menus page' do
        expect(page).to have_current_path menus_path
      end
    end
  end

  context 'New page' do
    before :each do
      visit menus_path
      click_button 'New Menu'
    end

    it 'should show all restaurants available in left-hand list' do

    end

    describe 'click Add button if' do
      scenario 'in left list, choose no restaurant' do

      end

      scenario 'in left list, choose some restaurants, some of them same as selected restaurants in right list' do

      end
    end

    describe 'click Remove button if' do
      scenario 'in right list, choose no restaurant' do

      end
      scenario 'in right list, choose some restaurants' do

      end
    end

    scenario 'select a specified date, click Create Menu' do

    end

    describe 'create menu without select date' do
      scenario 'with some selected restaurants' do

      end

      scenario 'with no restaurant' do

      end
    end

  end

  context 'Edit page' do
    it 'should show restaurants of that menu in right list' do

    end

    scenario 'save menu after remove all restaurants in left list' do

    end
  end

end
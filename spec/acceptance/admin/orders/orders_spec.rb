feature 'Handle Order', %q{
As an admin,
I want to add new order,
delete order for other users
} do
  let (:user1) {create(:user)}

  context 'New Order' do
    describe 'Go to [Admin] new order page' do
      it 'should show all dishes under pagination from' do

      end

      it 'should have pagination with exact functions' do

      end
    end

    context 'Find user' do
      let (:keyword) {user1.username[0..10]}
      it 'should call ajax after 2 sec delay with user\'s key up' do
      end

      it 'should show list user with username contain keyword' do

      end

    end

    context 'Change date' do
      it 'should show dishes correspond to menu of selected date' do

      end

      it 'should show nil if selected date has no menu' do

      end
    end

    context 'Select dish' do
      describe 'Click Add button' do
        it 'should add that dish to List Dishes' do

        end

        it 'should update total' do

        end
      end

      describe 'Click Remove button' do
        it 'should remove that dish from List Dishes' do

        end
        it 'should reduce total' do

        end
      end

    end
  end

  context 'Delete Order' do
    it 'should delete that order from Order table' do

    end

    it 'should delete dishes of that order from DishOrder' do

    end
  end

end
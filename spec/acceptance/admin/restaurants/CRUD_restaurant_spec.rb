feature 'New, Edit and Delete Restaurant', %q{
    As an admin,
I want to go to new form, edit or delete restaurant
} do
  context 'log in as normal user' do
    scenario 'go to new restaurant page' do

    end
    scenario 'go to edit page of an existed restaurant' do

    end

    scenario 'go to edit page of an non-exist restaurant' do

    end

    describe 'go to all restaurant page' do
      it 'should show restaurant name formed as link' do

      end

      describe 'click to restaurant name' do
        it 'should move to detail page when ' do

        end
      end

      it 'should active collapse effect when click to image logo of each restaurant' do

      end

      describe 'open collapse list for a restaurant' do

        it 'should show list dishes of that restaurant' do

        end

        it 'should show nothing if that restaurant have no dishes' do

        end
      end
    end
  end

  describe 'log in as admin user' do
    context 'edit page' do
      scenario 'go to edit restaurant page' do

      end

      scenario 'delete name, leave blank and save' do

      end

      scenario 'change name to same as an existed restaurant' do

      end

      scenario 'upload another image logo' do

      end

      scenario 'no upload anything' do

      end

      scenario 'change phone number, address' do

      end

      scenario 'change all things, then save' do

      end
    end

    describe 'go to all restaurant page' do
      before do
        #click a restaurant to see list dishes
      end

      it 'should show delete button for each dish' do

      end

      describe 'click Delete button of a dish and confirm' do
        it 'should delete that dish' do

        end

        it 'should redirect to all restaurants page' do

        end
      end

    end

    describe 'click to delete' do
      it 'should delete restaurant from list restaurant' do
      end

      it 'should delete dishes belonged to deleted restaurant ?' do

      end

      it 'make orders with deleted restaurant effected ?' do

      end
    end
  end
end
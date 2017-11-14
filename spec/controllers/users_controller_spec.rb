require 'spec_helper'

describe Admin::UsersController do
  describe '#new' do
    context 'login as admin' do
      let!(:user) {FactoryBot.create(:user)}
      let!(:admin) {FactoryBot.create(:user, admin: true)}

      before do
        visit root_path
      end

      it 'returns a 401 status code' do
        xhr :get, :create, @params
        expect(response.status).to equal(302)
      end

      it 'is an admin' do
        expect(admin.admin).to eq(1)
      end
    end
  end
end
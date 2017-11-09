require 'rails_helper'
describe Admin::UsersController do
  describe '#new' do
    context 'login' do
      let(:user) {FactoryBot.create(:user)}

      context 'as admin' do

        it "returns a 401 status code" do
          xhr :get, :create, @params
          expect(response.status).to equal(302)
        end

        context "when nvalid" do
          it {is_expected.to_not users_path}
        end

        context "when testing" do
          it {is_expected.to respond_with 302}
        end

        it "not isolate" do
          expect(response).to_not respond_with_unavailable_session
        end

        subject(:user_gay) {User.where("admin = ?", 1).first}

        it "is an admin" do

          puts "========================="
          puts user_gay.inspect
          puts "========================="


          expect(user_gay.admin).to 1
        end
      end
    end
  end
end
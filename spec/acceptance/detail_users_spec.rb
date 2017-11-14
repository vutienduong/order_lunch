require 'acceptance/acceptance_helper'
require 'support/utilitize'

feature "Detail user", %q{
details user} do
  let!(:admin) {create(:user, admin: true)}
  let!(:normal_user) {create(:user, admin: false)}

  context "test1" do
    before do
      logged_as normal_user
      visit users_path
    end
  end
end
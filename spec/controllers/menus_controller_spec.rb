require 'spec_helper'
# create menu
# menu without any dishes
# menu dish which not exist
# open, add. In other browser, delete that dish

describe MenusController, type: :controller do
  describe 'GET# show' do
    let! (:menu) {create(:menu)}
    before :each do
      @menu = Menu.last
    end

    it 'return 200 status' do
      get :show, id: @menu.id
      response.status.should == 200
    end

    it 'render exact template' do
      get :show, id: @menu.id
      expect(response).to render_template :show
    end
  end

end
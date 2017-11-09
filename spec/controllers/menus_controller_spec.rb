require 'rails_helper'
# create menu
# menu without any dishes
# menu dish which not exist
# open, add. In other browser, delete that dish

describe MenusController, type: :controller do
  describe "GET# show" do
    before :each do
      @menu = Menu.last
    end

    it "return 200 status" do
      puts "===#{@menu.inspect} ===="
      puts "===#{Menu.last.inspect} ===="
      get :show, id: @menu.id
      response.status.should == 200
    end

    it "render exact template" do
      get :show, menu: attributes_for(:menu)
      response.should render_template :show
    end
  end

end
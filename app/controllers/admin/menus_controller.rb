class Admin::MenusController < Admin::AdminsController
  def new
    @restaurants = Restaurant.all
    len = @restaurants.length
    @display_size = len < 20 ? len : 20
    @menu = Menu.new
    @dummy = {dummy: nil}
  end

  def create
    @menu = Menu.new(menu_params)
    raise MyError::CreateFailError.new @menu.errors.messages unless @menu.save
    redirect_to menu_path(@menu)
  end

  def edit
    @menu = Menu.find(params[:id])
    @restaurants = Restaurant.all
    len = @restaurants.length
    @display_size = len < 20 ? len : 20
  end

  def update
    @menu = Menu.find(params[:id])
    raise MyError::UpdateFailError.new @menu.errors.messages unless @menu.update(menu_params)
    redirect_to menu_path(@menu)
  end

  def request_menu
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    redirect_to menus_path
  end

  private
  def menu_params
    params.require(:menu).permit(:date, :restaurant_ids => [])
  end
end
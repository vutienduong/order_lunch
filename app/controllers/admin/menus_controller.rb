class Admin::MenusController < Admin::AdminsController
  def new
    @menu = Menu.new
    @dummy = {dummy: nil}
  end

  def create
    @menu = Menu.new(menu_params)
    raise CreateFailError @menu.errors.messages unless @menu.save
    redirect_to menu_path(@menu)
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update(menu_params)
      redirect_to menu_path(@menu)
    else
      @error = {code: '00x', msg: @menu.errors.messages}
      render 'layouts/error'
    end
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
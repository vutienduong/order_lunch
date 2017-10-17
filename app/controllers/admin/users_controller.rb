class Admin::UsersController < AdminsController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if session[:is_admin] and params[:id].to_i == session[:user_id]
      @error = ErrorCode::ERR_USER_DELETE_CURRENT_ADMIN
      render 'layouts/error'
    else
      @user.destroy
      redirect_to users_path
    end
  end

  def update
    @user = User.find(params[:id])
    #render params.inspect
    #return
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render plain: 'edit fail'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #log_in @user
      flash[:success] = "Welcome to the EH Order Lunch App!"
      redirect_to @user
    else
      render 'create'
    end
  end

  def manage
    @users = User.all
    @menus = Menu.includes(:restaurants).all
    @restaurants = Restaurant.includes(:dishes).all
    @dishes = Dish.all
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :admin)
  end

end
class SessionsController < ApplicationController
  include SessionsHelper
  layout 'sessions'

  def new
    if logged_in?
      render 'welcomes/index'
    else
      render 'new'
    end
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      log_in @user
      redirect_back_or @user
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def destroy
    log_out
    redirect_to login_url
  end
end

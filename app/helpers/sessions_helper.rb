module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:is_admin] = User.find(user.id).admin?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def is_admin?
    session[:is_admin]
  end

  def log_out
    session.delete([:user_id, :today_order, :today_order_id])
    @current_user = nil
  end

  def deny_access
    store_location
    redirect_to login_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end

end

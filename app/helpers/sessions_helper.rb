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
end

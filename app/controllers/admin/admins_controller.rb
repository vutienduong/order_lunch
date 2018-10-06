class Admin::AdminsController < ApplicationController
  before_action :require_login, :require_admin

  def require_admin
    unless current_user.admin?
      flash[:error] = 'Unauthorized access.'
      redirect_to root_path
    end
  end

  def index
  end
end

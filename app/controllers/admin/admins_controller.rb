class Admin::AdminsController < ApplicationController
  before_action :require_login, :require_admin

  def require_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end
end

class NoticesController < ApplicationController
  before_action :require_login

  def show
    @notice = Notice.find(params[:id])
  end
end

class Admin::UsersController < Admin::AdminsController
  def index
    @ol_settings = OlSetting.all
  end
end

class Admin::GeneralSettingsController < Admin::AdminsController
  def index
    @settings = GeneralSetting.all
  end

  def update_all_settings
    general_settings_params.each do |setting|
      GeneralSetting.find_by(key: setting[0])&.update(value: setting[1])
    end
    redirect_to admin_general_settings_path
  end

  def new
    @general_setting = GeneralSetting.new
  end

  def create
    key = general_setting_params['key']
    value = general_setting_params['value']
    GeneralSetting.where(key: key, value: value).first_or_create
    redirect_to admin_general_settings_path
  end

  private

  def general_settings_params
    params.require(:general_settings)
  end

  def general_setting_params
    params.require(:general_setting)
  end
end

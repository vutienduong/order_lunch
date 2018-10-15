class GeneralSetting < ActiveRecord::Base
  validates :key, uniqueness: true

  def self.get_setting(key)
    find_by(key: key)&.value
  end
end

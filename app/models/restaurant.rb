require 'open-uri'
class Restaurant < ActiveRecord::Base
  attr_reader :image_logo_remote_url
  validates :name, presence: true, uniqueness: true
  has_many :menu_restaurants
  has_many :menus, through: :menu_restaurants
  has_many :dishes

  scope :restaurants, -> { where("is_provider = '#{Rails.env.production? ? 0 : 'f'}' or is_provider is NULL") }
  scope :providers, -> { where(is_provider: true) }
  scope :by_date, lambda { |date|
    if is_provider?
      DailyRestaurant.where('DATE(date)=?', date)
    else
      self
    end
  }

  has_attached_file :image_logo, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image_logo, content_type: /\Aimage\/.*\Z/

  # TODO: we temporary do not validate image type, should fix later
  # do_not_validate_attachment_file_type :image_logo

  def image_logo_remote_url=(url_value)
    self.image_logo = URI.parse(url_value)
    @image_logo_remote_url = url_value
  end

  def dish_decorators
    show_dishes = dishes.compact
    variants = show_dishes.map &:variants
    variants.delete_if &:blank?
    variants.flatten!
    variants.each { |v| show_dishes.delete(v) }
    show_dishes
  end

  def all_dishes(date)
    return dishes unless is_provider?
    DailyRestaurant
        .find_by(restaurant_id: id, date: date)
        .dishes
  end

  def test_res_method
    puts 'This is test Restaurant'
  end

  def by_date(date)
    if is_provider?
      drest = DailyRestaurant.where('DATE(date)=?', date)
          .find_by(restaurant_id: id)
      drest.blank? ? self : drest
    else
      self
    end
  end

  def provider_by_date(date)
    DailyRestaurant.where('DATE(date)=?', date)
        .find_by(restaurant_id: id)
  end

  def load_dishes(date = nil)
    return [] if date.blank?
    if is_provider?
      parse_date = date.is_a?(Date) ? date : Date.parse(date)
      return [] unless parse_date.is_a?(Date)
      daily_restaurants.find_by(date: parse_date)&.dishes
    else
      dishes
    end
  end

  def provider
    Provider.find(id)
  end
end

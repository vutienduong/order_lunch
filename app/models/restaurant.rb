class Restaurant < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :menu_restaurants
  has_many :menus, through: :menu_restaurants
  has_many :dishes
end

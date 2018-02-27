class Menu < ActiveRecord::Base
  validates :restaurants, presence: true
  validates :date, presence: true, uniqueness: true

  has_many :menu_restaurants
  has_many :restaurants, through: :menu_restaurants
  accepts_nested_attributes_for :restaurants

  attr_accessor :provider_ids
end


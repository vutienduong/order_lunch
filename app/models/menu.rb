class Menu < ActiveRecord::Base
  validates :restaurants, presence: true
  validates :date, presence: true, uniqueness: true

  has_many :menu_restaurants
  has_many :menu_histories
  has_many :restaurants, through: :menu_restaurants
  accepts_nested_attributes_for :restaurants

  attr_accessor :provider_ids

  def lock!(time)
    update(is_lock: true, locked_at: time)
  end

  def open!
    update(is_lock: false)
  end
end


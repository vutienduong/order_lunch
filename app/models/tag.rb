class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :external_id }
  has_and_belongs_to_many :dishes
end

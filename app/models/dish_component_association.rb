class DishComponentAssociation < ActiveRecord::Base
  belongs_to :dish, -> { where(componentable: 1) }
  belongs_to :dished_component
end

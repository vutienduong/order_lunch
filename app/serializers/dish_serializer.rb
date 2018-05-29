class DishSerializer < ActiveModel::Serializer
  attributes :id, :restaurant_id, :name, :price, :description, :sizeable, :tags_id
end

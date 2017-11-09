require 'faker'

FactoryBot.define do
  factory :dish do |f|
    f.name {Faker::Name.name}
    f.restaurant
    f.price {Faker::Number.between(1000, 80000)}
  end

  factory :invalid_dish, parent: :dish do |f|
    f.name = nil
  end
end
require 'faker'

FactoryBot.define do
  factory :restaurant do |f|
    f.name {Faker::Name.unique.title}
    f.address {Faker::Address.city}
    f.phone {Faker::PhoneNumber.phone_number}
  end
end
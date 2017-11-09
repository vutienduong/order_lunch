require 'faker'

FactoryBot.define do
  factory :order do |f|
    byebug
    f.name {Faker::Name.title}
    f.address {Faker::Address.city}
    f.phone {Faker::PhoneNumber.phone_number}
  end
end
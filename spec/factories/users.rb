require 'faker'

FactoryBot.define do
  factory :user do |f|
    f.username {Faker::Name.name}
    f.email {Faker::Internet.email}
    f.password "1"
  end
end
require 'faker'

FactoryBot.define do
  factory :menu do |f|
    f.date {Faker::Date.unique.between('2017-01-01', '2017-12-31')}
    f.restaurants {[FactoryBot.create(:restaurant)]}
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

=begin
restaurants = Restaurant.create([{name: 'sukiya', address: 'Ho Chi Minh City'}, {name: 'bento taiwan', address: 'Ho Chi Minh city'}])

names = ["com bo ham", "com bo trung hong dao", "com bo hanh", "com bo pho mai"]
images = ["sukiya_1", "sukiya_2", "sukiya_3", "sukiya_4"]
prices = [42000, 48000, 52000, 58000]


4.times do |i|
  Dish.create(name: "#{names[i]}",
              description: "...",
              price: "#{prices[i]}",
              image_url: "#{images[i]}",
              restaurant: restaurants.first)
end
=end

# =======================================

=begin

names = ["bento suon cotlet chien", "bento suon cotlet kho", "bento gio heo kho", "bento thit kho tieu"]
images = ["bento_1", "bento_2", "bento_3", "bento_4"]
prices = [35000, 35000, 35000, 35000]

4.times do |i|
  Dish.create(name: "#{names[i]}",
              description: "...",
              price: "#{prices[i]}",
              image_url: "#{images[i]}",
              restaurant: Restaurant.last)
end=end

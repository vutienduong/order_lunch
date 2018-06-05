namespace :grant_once_to_existed_dishes do
  desc 'Grant once to dishes, default = true, only dishes of provider can has once = false'
  task grant_once: :environment do
    Dish.find_each do |d|
      d.update(once: true)
    end
  end
end

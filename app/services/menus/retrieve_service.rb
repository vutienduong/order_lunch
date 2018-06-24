class Menus::RetrieveService
  def initialize(menu)
    @menu = menu
  end

  def collect_follow_tags_for_each_restaurant
    r_tags = {}
    compared_time = Time.current
    @menu.restaurants.each do |restaurant|
      locked_at = @menu.get_menu_restaurant_with(restaurant.id)&.locked_at
      next if locked_at.present? && locked_at < compared_time

      temp_tag = {}
      restaurant.by_date(@select_date).dishes.group_by(&:tags).each do |tag, dish|
        name = tag.first
        temp_tag[name] = [] unless temp_tag[name]
        temp_tag[name].push dish
      end
      r_tags[restaurant.id.to_s] = temp_tag
    end
    r_tags
  end
end

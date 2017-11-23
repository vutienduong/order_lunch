module ApplicationHelper
  NUMBER_OF_DISH_PER_PAGE = 30

  def display_cost_as_thousand(cost)
    "#{cost/1000} k VND"
  end

  def date_format(date)
    date.gregorian
  end

  def page_title(name)
    render html: "<h1>#{name}</h1>".html_safe
  end

  def show_id_included_blank prefix_id, obj
    obj.blank? ? "#{prefix_id}_nil" : "#{prefix_id}_#{obj.id.to_s}"
  end
end

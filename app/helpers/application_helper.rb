module ApplicationHelper
  NUMBER_OF_DISH_PER_PAGE = 3
  def display_cost_as_thousand(cost)
    "#{cost/1000} k VND"
  end

  def date_format(date)
    date.gregorian
  end

  def page_title(name)
    render html: "<h1>#{name}</h1>".html_safe
  end
end

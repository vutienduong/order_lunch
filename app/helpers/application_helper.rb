module ApplicationHelper
  NUMBER_OF_DISH_PER_PAGE = 3
  def displayCostAsThousand(cost)
    "#{cost/1000} k VND"
  end

  def dateFormat(date)
    date.gregorian
  end

  def pageTitle(name)
    render html: "<h1>#{name}</h1>".html_safe
  end
end

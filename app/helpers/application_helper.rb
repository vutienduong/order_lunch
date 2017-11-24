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

  def parse_date_string_to_date str
    Date.parse(str).to_date
  end

  def additional_info_for_current_date date
    if date.eql? Date.today
      'today'
    elsif date.eql? Date.today - 1
      'yesterday'
    elsif date.eql? Date.today + 1
      'tomorrow'
    elsif date < Date.today
      'past'
    else
      'future'
    end
  end
end

module DateHelper
  def to_date_in_time_zone(date)
    date.blank? ? '' : date.in_time_zone('Hanoi')
  end

  def weekdays_in_month_given_a_date(date)
    range = (date.beginning_of_month..date.end_of_month)
    range.select { |d| (1..5).cover?(d.wday) }.size
  end
end

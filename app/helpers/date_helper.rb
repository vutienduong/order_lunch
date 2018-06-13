module DateHelper
  def to_date_in_time_zone(date)
    date.blank? ? '' : date.in_time_zone('Hanoi')
  end
end

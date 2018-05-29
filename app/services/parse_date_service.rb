class ParseDateService
  def self.parse_date(date, format = nil)
    return Date.strptime(date, "%m/%d/%Y") if format.nil?
    Date.strptime(date, format)
  end
end

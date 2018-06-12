class ParseDateService
  def self.parse_date(date, format = nil)
    return Date.strptime(date, "%m/%d/%Y") if format.nil?
    Date.strptime(date, format)
  end

  def self.convert_array_to_time(arr)
    des = %w[2018 1 1 0 0]
    arr.each_with_index do |val, idx|
      des[idx] = val[1]
    end
    Time.new(des[0], des[1], des[2], des[3], des[4], "+07:00")
  end
end

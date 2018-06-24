class ParseDateService
  def self.parse_date(date, format = nil)
    return Date.strptime(date, "%m/%d/%Y") if format.nil?
    Date.strptime(date, format)
  end

  def self.convert_array_to_local_time(arr, offset)
    des = %w[2018 1 1 0 0]
    arr.each_with_index do |val, idx|
      des[idx] = val[1]
    end
    Time.new(des[0], des[1], des[2], des[3], des[4], offset)
  end

  def self.convert_offset_to_time_zone(offset)
    # example: -420 => "+07:00"

    offset_i = offset.to_i
    number = offset_i.abs / 60
    sign = offset_i.negative? ? '+' : '-'
    number = number < 10 ? "0#{number}" : number.to_s
    "#{sign}#{number}:00"
  end
end

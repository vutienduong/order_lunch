module Formatter
  class Currency
    def self.to_default(price)
      if price == AverageCostService::ERROR_MSG
        "[ #{price} ]"
      else
        price = price.floor.to_s.reverse.split('')
        length = price.length
        rev_price = price.each_with_index.map do |x, i|
          ((i % 3 == 2) && i != (length - 1)) ? "#{x}," : x
        end
        rev_price.join.reverse.to_s
      end
    end

    def self.get_subtract_catch_exception(num1, num2)
      to_default(num1 - num2)
    rescue StandardError => _e
      "[ #{AverageCostService::ERROR_MSG} ]"
    end
  end
end

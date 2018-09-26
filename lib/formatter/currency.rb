module Formatter
  class Currency
    def self.to_default(price)
      price = price.floor.to_s.reverse.split('')
      rev_price = price.each_with_index.map do |x, i|
        i % 3 == 2 ? "#{x}," : x
      end
      rev_price.join.reverse.to_s
    end
  end
end

module CurrencyHelper
  def to_default_currency(price)
    Formatter::Currency.to_default(price)
  end
end

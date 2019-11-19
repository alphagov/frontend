module CurrencyHelper
  def format_amount(number)
    number_to_currency(number, unit: "euros", precision: 0, format: "%n %u")
  end
end

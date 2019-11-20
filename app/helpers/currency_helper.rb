module CurrencyHelper
  def format_amount(number)
    if number.present?
      number_to_currency(number, unit: "euros", precision: 0, format: "%n %u")
    end
  end
end

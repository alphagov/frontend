module ThemeTypeHelper
  def style(theme_colour)
    valid_numbers = (1..6)
    return "theme-default" unless valid_numbers.include?(theme_colour)

    "theme-#{theme_colour}"
  end
end

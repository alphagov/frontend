module DateTimeHelper
  def format_date(datetime)
    datetime.to_datetime.strftime("%-d %B %Y")
  end
end

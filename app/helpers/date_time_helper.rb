module DateTimeHelper
  def format_date(datetime)
    if datetime.present?
      datetime.to_datetime.strftime("%-d %B %Y")
    end
  end
end

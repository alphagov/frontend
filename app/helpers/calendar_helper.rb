module CalendarHelper
  def time_tag_safe(date)
    tag.time(datetime: date) { l(date, format: "%e %B") }.html_safe
  end

  def format_date(date)
    l date, format: "%e %B %Y"
  end
end

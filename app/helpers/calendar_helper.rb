module CalendarHelper
  def last_updated_date
    File.mtime(Rails.root.join("REVISION")).to_date
  rescue StandardError
    Time.zone.today
  end

  def time_tag_safe(date)
    tag.time(datetime: date) { l(date, format: "%e %B") }.html_safe
  end
end

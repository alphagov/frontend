module CalendarHelper
  def last_updated_date
    File.mtime(Rails.root.join("REVISION")).to_date
  rescue StandardError
    Time.zone.today
  end

  def format_date(date)
    l date, format: "%e %B %Y"
  end
end

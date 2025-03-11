module DateHelper
  def display_date(timestamp, format = "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format:, locale: I18n.locale) if timestamp
  end
end

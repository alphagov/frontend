module DateHelper
  def display_date(timestamp, format = "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format:, locale: I18n.locale) if timestamp
  end

  def formatted_history(history)
    history.map do |change|
      {
        display_time: display_date(change[:timestamp]),
        note: change[:note],
        timestamp: change[:timestamp],
      }
    end
  end
end

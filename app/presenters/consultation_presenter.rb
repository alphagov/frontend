class ConsultationPresenter < ContentItemPresenter
  def opening_date
    display_date_and_time(content_item.opening_date_time)
  end

  def opening_date_midnight?
    Time.zone.parse(content_item.opening_date_time).strftime("%l:%M%P") == "12:00am"
  end

private

  def display_date_and_time(date, rollback_midnight: false)
    time = Time.zone.parse(date)
    date_format = "%-e %B %Y"
    time_format = "%l:%M%P"

    if rollback_midnight && (time.strftime(time_format) == "12:00am")
      # 12am, 12:00am and "midnight on" can all be misinterpreted
      # Use 11:59pm on the day before to remove ambiguity
      # 12am on 10 January becomes 11:59pm on 9 January
      time -= 1.second
    end
    I18n.l(time, format: "#{time_format} #{I18n.t('formats.consultation.on')} #{date_format}").gsub(":00", "").gsub("12pm", "midday").gsub("12am #{I18n.t('formats.consultation.on')} ", "").strip
  end
end

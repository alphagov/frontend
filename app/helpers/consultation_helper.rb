module ConsultationHelper
  def opening_date(opening_date_time)
    display_date_and_time(opening_date_time)
  end

  def closing_date(closing_date_time)
    display_date_and_time(closing_date_time, rollback_midnight: true)
  end

  def on_or_at(opening_date_time)
    opening_date_midnight?(opening_date_time) ? I18n.t("common.on") : I18n.t("common.at")
  end

  def opens_closes_or_ran(phase, schema_name)
    locale_key = ""

    case phase
    when "closed_#{schema_name}"
      locale_key = "ran_from"
    when "#{schema_name}_outcome"
      locale_key = "ran_from"
    when "open_#{schema_name}"
      locale_key = "closes_at"
    else
      return I18n.t("formats.#{schema_name}.opens") + " #{I18n.t('common.at')}"
    end

    I18n.t("formats.#{schema_name}.#{locale_key}")
  end

private

  def display_date_and_time(date, rollback_midnight: false)
    time = Time.zone.parse(date)
    date_format = "%-e %B %Y"
    time_format = "%l:%M%P"
    on = I18n.t("common.on")

    if rollback_midnight && (time.strftime(time_format) == "12:00am")
      # 12am, 12:00am and "midnight on" can all be misinterpreted
      # Use 11:59pm on the day before to remove ambiguity
      # 12am on 10 January becomes 11:59pm on 9 January
      time -= 1.second
    end
    I18n.l(time, format: "#{time_format} #{on} #{date_format}").gsub(":00", "").gsub("12pm", "midday").gsub("12am #{on} ", "").strip
  end

  def opening_date_midnight?(opening_date_time)
    Time.zone.parse(opening_date_time).strftime("%l:%M%P") == "12:00am"
  end
end

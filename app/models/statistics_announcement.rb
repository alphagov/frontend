class StatisticsAnnouncement < ContentItem
  include Updatable
  FORTHCOMING_NOTICE = I18n.t("formats.statistics_announcement.forthcoming").freeze

  def release_date
    content_store_response.dig("details", "display_date")
  end

  def release_date_and_status
    return "#{release_date} (#{state})" unless cancelled?

    release_date
  end

  def release_date_changed?
    content_store_response["details"].include?("previous_display_date")
  end

  def forthcoming_publication?
    !cancelled?
  end

  def forthcoming_notice_title
    "#{FORTHCOMING_NOTICE} #{on_in_between_for_release_date(release_date)}"
  end

  def cancellation_date
    cancelled_at = content_store_response["details"]["cancelled_at"]
    Time.zone.parse(cancelled_at).strftime("%e %B %Y %-l:%M%P")
  end

  def cancellation_reason
    content_store_response["details"]["cancellation_reason"]
  end

  def previous_release_date
    content_store_response["details"]["previous_display_date"]
  end

  def release_date_change_reason
    content_store_response["details"]["latest_change_note"]
  end

  def on_in_between_for_release_date(date)
    return "on #{date}" if date_is_exact_format?(date)
    return "in #{date}" if date_is_one_month_format?(date)
    return "between #{replace_on_with_and(date)}" if date_is_two_month_format?(date)

    date
  end

  def cancelled?
    state == "cancelled"
  end

  def national_statistics?
    document_type == "national_statistics_announcement"
  end

  private

  def state
    content_store_response["details"]["state"]
  end

  def replace_on_with_and(date_in_two_month_format)
    re = /\s(to)\s/
    date_in_two_month_format.sub(re, " and ")
  end

  def date_is_two_month_format?(date)
    date =~ /\A(\w+)\s(to)\s(\w+)/
  end

  def date_is_one_month_format?(date)
    date =~ /\A(\w+)\s(\d{1,4})/
  end

  def date_is_exact_format?(date)
    date.downcase =~ /\A(\d{1,2})\s(\w+)\s(\d{4})\s(\d{1,2}:\d{1,2})(am|pm)/
  end
end
class StatisticsAnnouncement < ContentItem
  include Updatable

  FORTHCOMING_NOTICE = I18n.t("statistics_announcement.forthcoming").freeze

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

  def cancelled?
    state == "cancelled"
  end

  private

  def state
    content_store_response["details"]["state"]
  end
end
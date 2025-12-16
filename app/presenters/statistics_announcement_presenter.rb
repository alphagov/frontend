class StatisticsAnnouncementPresenter < ContentItemPresenter
  include StatisticsAnnouncementHelper
  include NationalStatisticsLogo

  def important_metadata
    metadata = {}
    if content_item.cancelled?
      metadata.merge!(
        I18n.t("formats.statistics_announcement.proposed_date") => content_item.release_date,
        I18n.t("formats.statistics_announcement.cancellation_date") => content_item.cancellation_date,
      )
    else
      metadata.merge!(I18n.t("formats.statistics_announcement.release_date") => content_item.release_date_and_status)
    end

    metadata
  end
end

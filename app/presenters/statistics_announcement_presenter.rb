class StatisticsAnnouncementPresenter < ContentItemPresenter
  def important_metadata
    super.tap do |m|
      if cancelled?
        m.merge!(
          I18n.t("statistics_announcement.proposed_date") => release_date,
          I18n.t("statistics_announcement.cancellation_date") => cancellation_date,
        )
      else
        m.merge!(I18n.t("statistics_announcement.release_date") => release_date_and_status)
      end
    end
  end
end
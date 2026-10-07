class StatisticsAnnouncementPresenter < ContentItemPresenter
  include StatisticsAnnouncementHelper
  include NationalStatisticsLogo
  include DateHelper
  include LinkHelper

  def use_contextual_components?
    true
  end

  def page_title_options
    data = {
      metadata: {
        from: govuk_styled_links_list(contributor_links),
        first_published: content_item.respond_to?(:initial_publication_date) ? display_date(content_item.initial_publication_date) : nil,
        last_updated: display_date(content_item.updated),
      },
    }
    if logo
      data[:logo] = {
        path: ActionController::Base.helpers.asset_path(logo[:path]),
        alt_text: logo[:alt_text],
        statistics_logo: true,
      }
    end
    super.merge(data)
  end

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

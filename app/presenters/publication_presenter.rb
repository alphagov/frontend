class PublicationPresenter < ContentItemPresenter
  include NationalStatisticsLogo
  include LinkHelper
  include DateHelper

  PATHS_TO_HIDE = %w[
    /government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data
    /government/publications/govuk-test-app-privacy-notice
    /government/publications/pension-credit-claim-form--2
    /government/publications/hpv-self-testing-kit-instructions
    /government/publications/hpv-self-testing-a-self-test-to-help-protect-against-cervical-cancer
    /government/publications/hpv-self-testing-easy-read-letter-templates
    /government/publications/hpv-self-testing-easy-guides
  ].freeze

  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      metadata: {
        from: govuk_styled_links_list(contributor_links),
        first_published: display_date(content_item.initial_publication_date),
        last_updated: display_date(content_item.updated),
        page_history: formatted_history(content_item.history),
        page_history_details_ga4: {
          type: "content history",
          section: "Top",
        },
      },
      logo: logo,
    })
  end

  def hide_from_search_engines?
    PATHS_TO_HIDE.any? do |path_to_hide|
      base_path = content_item.base_path
      locale = content_item.locale

      unless locale == "en"
        base_path = content_item.base_path.gsub(".#{locale}", "")
      end

      path_to_hide == base_path
    end
  end
end

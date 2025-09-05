class PublicationPresenter < ContentItemPresenter
  include NationalStatisticsLogo

  PATHS_TO_HIDE = %w[
    /government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data
    /government/publications/pension-credit-claim-form--2
    /guidance/about-govuk-chat
    /guidance/govuk-chat-terms-and-conditions
  ].freeze

  def hide_from_search_engines?
    PATHS_TO_HIDE.include?(content_item.base_path)
  end
end

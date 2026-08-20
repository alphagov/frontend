class PublicationPresenter < ContentItemPresenter
  include NationalStatisticsLogo

  PATHS_TO_HIDE = %w[
    /government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data
    /government/publications/govuk-test-app-privacy-notice
    /government/publications/pension-credit-claim-form--2
    /government/publications/hpv-self-testing-kit-instructions
    /government/publications/hpv-self-testing-a-self-test-to-help-protect-against-cervical-cancer
    /government/publications/hpv-self-testing-easy-read-letter-templates
    /government/publications/hpv-self-testing-easy-guides
  ].freeze

  def hide_from_search_engines?
    PATHS_TO_HIDE.include?(content_item.base_path)
  end
end

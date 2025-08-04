class PublicationPresenter < ContentItemPresenter
  PATHS_TO_HIDE = %w[
    /government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data
    /government/publications/pension-credit-claim-form--2
  ].freeze

  def hide_from_search_engines?
    PATHS_TO_HIDE.include?(content_item.base_path)
  end
end

class Publication < ContentItem
  DATASETS = %w[national_statistics official_statistics transparency].freeze

  PATHS_TO_HIDE = %w[
    /government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data
    /government/publications/pension-credit-claim-form--2
  ].freeze

  def dataset?
    DATASETS.include? document_type
  end

  def hide_from_search_engines?
    PATHS_TO_HIDE.include?(base_path)
  end
end

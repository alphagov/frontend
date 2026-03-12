class DetailedGuidePresenter < ContentItemPresenter
  include ContentsList

  PATHS_TO_HIDE = %w[
    /guidance/about-govuk-chat
    /guidance/govuk-chat-terms-and-conditions
  ].freeze

  def logo
    return unless content_item.image

    { path: content_item.image["url"], alt_text: "European structural investment funds" }
  end

  def hide_from_search_engines?
    PATHS_TO_HIDE.include?(content_item.base_path)
  end
end

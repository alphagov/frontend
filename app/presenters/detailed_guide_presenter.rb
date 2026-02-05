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

  def ga4_scroll_tracking?
    ["/guidance/30-month-local-plan-process-an-overview",
     "/guidance/getting-ready-to-prepare-a-new-plan",
     "/guidance/giving-notice-of-your-plan-making",
     "/guidance/gateway-1-what-you-need-to-do",
     "/guidance/gathering-baselining-information-to-inform-a-local-plan",
     "/guidance/preparing-a-local-plan-vision",
     "/guidance/selecting-identifying-and-assessing-sites-for-local-plans",
     "/guidance/identifying-sites-for-local-plans-stage-1",
     "/guidance/assessing-sites-for-local-plans-stage-2",
     "/guidance/determining-your-draft-allocations-for-local-plans-stage-3",
     "/guidance/confirming-draft-allocations-and-recording-decisions-for-local-plans-stage-4"].include?(content_item.base_path)
  end
end

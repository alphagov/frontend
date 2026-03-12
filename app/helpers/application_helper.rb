module ApplicationHelper
  def page_title(content_item = nil)
    withdrawn = content_item.respond_to?(:withdrawn?) && content_item.withdrawn?
    build_page_title([content_item&.title], withdrawn:)
  end

  def build_page_title(elements = [], withdrawn: false)
    title = (elements + ["GOV.UK"]).compact.join(" - ")
    withdrawn ? "[Withdrawn] #{title}" : title
  end

  def current_path_without_query_string
    request.original_fullpath.split("?", 2).first
  end

  def show_breadcrumbs?(content_item)
    return false if content_item.nil?

    no_breadcrumbs_for = %w[flexible_page
                            history
                            homepage
                            landing_page
                            service_manual_homepage
                            service_manual_guide
                            service_manual_service_standard
                            service_manual_service_toolkit
                            service_manual_topic
                            topical_event
                            topical_event_about_page
                            worldwide_corporate_information_page
                            worldwide_office
                            worldwide_organisation]

    return false if no_breadcrumbs_for.include?(content_item.schema_name)

    true
  end

  def show_app_promo_banner?
    return false unless content_item && content_item.base_path

    [
      "/get-vehicle-information-from-dvla",
      "/bring-pet-to-great-britain",
      "/state-pension",
      "/sign-in-to-manage-your-student-loan-balance",
      "/school-term-holiday-dates",
    ].include?(content_item.base_path)
  end

  PERCENTAGE_SCROLL_TRACKING_URLS = [
    "/apply-to-come-to-the-uk",
    "/apply-to-come-to-the-uk/getting-a-decision-on-your-application",
    "/apply-to-come-to-the-uk/prepare-your-application",
    "/apply-to-come-to-the-uk/prove-your-identity",
    "/government/collections/create-or-update-a-local-plan-using-the-new-system",
    "/government/publications/rollout-of-the-new-local-plan-making-system",
    "/guidance/30-month-local-plan-process-an-overview",
    "/guidance/assessing-sites-for-local-plans-stage-2",
    "/guidance/confirming-draft-allocations-and-recording-decisions-for-local-plans-stage-4",
    "/guidance/determining-your-draft-allocations-for-local-plans-stage-3",
    "/guidance/gateway-1-what-you-need-to-do",
    "/guidance/gathering-baselining-information-to-inform-a-local-plan",
    "/guidance/getting-ready-to-prepare-a-new-plan",
    "/guidance/giving-notice-of-your-plan-making",
    "/guidance/identifying-sites-for-local-plans-stage-1",
    "/guidance/preparing-a-local-plan-vision",
    "/guidance/selecting-identifying-and-assessing-sites-for-local-plans",
  ].freeze

  def include_percentage_scroll_tracking?
    return false unless content_item && content_item.base_path

    PERCENTAGE_SCROLL_TRACKING_URLS.include?(content_item.base_path)
  end
end

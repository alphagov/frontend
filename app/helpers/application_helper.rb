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

    no_breadcrumbs_for = %w[history
                            homepage
                            mini_site
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
    "/apply-postal-vote",
    "/register-to-vote",
    "/guidance/sign-up-for-making-tax-digital-for-income-tax",
    "/guidance/use-making-tax-digital-for-income-tax",
    "/guidance/use-making-tax-digital-for-income-tax/access-your-new-making-tax-digital-for-income-tax-service-after-you-sign-up",
    "/guidance/use-making-tax-digital-for-income-tax/adjust-your-self-employment-and-property-income",
    "/guidance/use-making-tax-digital-for-income-tax/before-you-use-this-guide",
    "/guidance/use-making-tax-digital-for-income-tax/create-digital-records",
    "/guidance/use-making-tax-digital-for-income-tax/get-your-software-ready",
    "/guidance/use-making-tax-digital-for-income-tax/help-and-support",
    "/guidance/use-making-tax-digital-for-income-tax/if-your-circumstances-change",
    "/guidance/use-making-tax-digital-for-income-tax/send-quarterly-updates",
    "/government/collections/making-tax-digital-for-income-tax",
    "/government/collections/making-tax-digital-for-income-tax-as-an-agent-step-by-step",
    "/government/collections/making-tax-digital-for-income-tax-for-sole-traders-and-landlords-step-by-step",
    "/guidance/use-making-tax-digital-for-income-tax/submit-your-tax-return",
    "/guidance/find-out-if-you-can-get-an-exemption-from-making-tax-digital-for-income-tax",
    "/guidance/apply-for-an-exemption-from-making-tax-digital-for-income-tax",
    "/guidance/penalties-for-income-tax-self-assessment-volunteers",
    "/guidance/choose-agents-for-making-tax-digital-for-income-tax",
    "/guidance/sign-up-your-client-for-making-tax-digital-for-income-tax",
    "/guidance/add-your-client-authorisations-for-making-tax-digital-for-income-tax",
    "/guidance/work-out-your-qualifying-income-for-making-tax-digital-for-income-tax",
    "/guidance/penalties-for-making-tax-digital-for-income-tax",
    "/guidance/choose-the-right-software-for-making-tax-digital-for-income-tax",
    "/guidance/find-out-if-and-when-you-need-to-use-making-tax-digital-for-income-tax",
    "/guidance/find-software-that-works-with-making-tax-digital-for-income-tax",
    "/guidance/check-what-to-do-if-hmrc-has-signed-you-up-for-making-tax-digital-for-income-tax",
  ].freeze
  HEADER_SCROLL_TRACKING_URLS = [
    "/private-renting",
    "/assured-periodic-tenancies-tenants",
    "/rental-discrimination-tenants",
    "/private-renting-evictions",
    "/renting-out-a-property",
    "/assured-tenancy-agreements-a-guide-for-landlords",
    "/rental-discrimination-landlords",
    "/evicting-tenants",
    "/apply-to-come-to-the-uk",
    "/guidance/starting-a-food-business",
    "/running-food-business",
    "/running-food-business/staff-training-illness-hygiene",
    "/running-food-business/allergies",
    "/running-food-business/suppliers-and-traceability",
    "/running-food-business/food-inspections",
    "/food-safety-management-systems",
    "/food-safety-management-systems/creating-a-food-safety-management-system",
    "/food-safety-management-systems/make-an-haccp-plan",
    "/food-hygiene-businesses",
    "/food-hygiene-businesses/cooking",
    "/food-hygiene-businesses/chilling-and-freezing",
    "/food-hygiene-businesses/cleaning",
    "/food-hygiene-businesses/cross-contamination",
    "/food-hygiene-businesses/storing-and-transporting-food",
    "/government/publications/food-hygiene-rating-scheme-fhrs-guidance-for-businesses/food-hygiene-rating-scheme-fhrs-guidance-for-businesses",
    "/government/publications/food-hygiene-rating-scheme/food-hygiene-rating-scheme",
    "/guidance/food-business-registration",
    "/guidance/hazard-analysis-and-critical-control-point-haccp",
    "/government/publications/food-safety-for-food-delivery/food-safety-for-food-delivery",
    "/government/publications/providing-food-at-community-and-charity-events/providing-food-at-community-and-charity-events",
    "/government/publications/businesses-that-supply-or-produce-food-on-the-move/businesses-that-supply-or-produce-food-on-the-move",
  ].freeze

  def include_percentage_scroll_tracking?
    return false unless content_item && content_item.base_path

    PERCENTAGE_SCROLL_TRACKING_URLS.include?(content_item.base_path)
  end

  def include_header_scroll_tracking?
    return false unless content_item && content_item.base_path

    HEADER_SCROLL_TRACKING_URLS.include?(content_item.base_path)
  end
end

module ApplicationHelper
  def page_title(content_item = nil)
    title = content_item.title if content_item
    [title, "GOV.UK"].select(&:present?).join(" - ")
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
                            topical_event_about_page]

    return false if no_breadcrumbs_for.include?(content_item.schema_name)

    true
  end

  def show_ios_banner?
    return false unless content_item && content_item.base_path

    [
      "/get-vehicle-information-from-dvla",
      "/bring-pet-to-great-britain",
      "/state-pension",
      "/sign-in-to-manage-your-student-loan-balance",
      "/school-term-holiday-dates",
    ].include?(content_item.base_path)
  end
end

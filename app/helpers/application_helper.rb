module ApplicationHelper
  def page_title(content_item = nil)
    title = content_item.title if content_item
    [title, "GOV.UK"].select(&:present?).join(" - ")
  end

  def wrapper_class(content_item = nil)
    services = %w[transaction local_transaction place]
    html_classes = []

    if content_item
      html_classes << content_item.schema_name if content_item.schema_name
      html_classes << "travel-advice" if content_item.schema_name == "travel_advice_index"
      html_classes << "service" if services.include? content_item.schema_name
    end

    html_classes.join(" ")
  end

  def current_path_without_query_string
    request.original_fullpath.split("?", 2).first
  end

  def show_breadcrumbs?(content_item)
    return false if content_item.nil?

    no_breadcrumbs_for = %w[flexible_page homepage landing_page]

    return false if no_breadcrumbs_for.include?(content_item.schema_name)

    true
  end
end

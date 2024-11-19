module ApplicationHelper
  def page_title(publication = nil)
    title = publication.title if publication
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

  def remove_breadcrumbs(content_item)
    remove_breadcrumbs = false

    if content_item.respond_to?(:is_a_landing_page?) && content_item.is_a_landing_page?
      remove_breadcrumbs = true
    end

    remove_breadcrumbs
  end
end

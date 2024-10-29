module ApplicationHelper
  def page_title(publication = nil)
    title = publication.title if publication
    [title, "GOV.UK"].select(&:present?).join(" - ")
  end

  def wrapper_class(publication = nil)
    services = %w[transaction local_transaction place]
    html_classes = []

    if publication
      html_classes << publication.format if publication.format
      html_classes << "service" if services.include? publication.format
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

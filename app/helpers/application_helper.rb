module ApplicationHelper
  def page_title(publication = nil)
    title = publication.title if publication
    [title, "GOV.UK"].select(&:present?).join(" - ")
  end

  def wrapper_class(publication = nil)
    services = %w[transaction local_transaction place]
    html_classes = []

    if publication
      if publication.respond_to?(:wrapper_classes)
        html_classes = publication.wrapper_classes
      else
        if publication.format
          html_classes << publication.format
        end

        if services.include? publication.format
          html_classes << "service"
        end
      end
    end

    html_classes.join(" ")
  end

  def current_path_without_query_string
    request.original_fullpath.split("?", 2).first
  end
end

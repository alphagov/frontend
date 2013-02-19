module ApplicationHelper
  def page_title(artefact, publication=nil)
    if publication
      title = [publication.title, publication.alternative_title].find(&:present?)
      title = "Video - #{title}" if request.format.video?
    end
    [title, 'GOV.UK'].select(&:present?).join(" - ")
  end

  def wrapper_class(publication = nil)
    services = %W[transaction local_transaction completed_transaction place]
    answers = %W[answer business_support]
    guides = %W[guide travel-advice]
    html_classes = []

    if publication
      if publication.respond_to?(:wrapper_classes)
        html_classes = publication.wrapper_classes
      else
        if publication.type
          html_classes << publication.type
        end

        if request.format.video?
          html_classes << "video-guide"
        end

        if services.include? publication.type
          html_classes << "service"
        end

        if answers.include? publication.type
          html_classes << "answer"
        end

        if guides.include? publication.type
          html_classes << "guide"
        end
      end
    end

    html_classes.join(' ')
  end

  def publication_api_path(publication, opts = {})
    path = "/api/#{CGI.escape publication.slug}.json"
    path += "?edition=#{opts[:edition]}" if opts[:edition]
    path
  end
end

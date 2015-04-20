module ApplicationHelper
  def page_title(publication = nil)
    if publication
      title = publication.title
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
        if publication.format
          html_classes << publication.format
        end

        if request.format.video?
          html_classes << "video-guide"
        end

        if services.include? publication.format
          html_classes << "service"
        end

        if answers.include? publication.format
          html_classes << "answer"
        end

        if guides.include? publication.format
          html_classes << "guide"
        end
      end
    end

    html_classes.join(' ')
  end

  def publication_api_path(publication, opts = {})
    path = "/api/#{publication.slug}.json"
    path += "?edition=#{opts[:edition]}" if opts[:edition]
    path
  end

  def previous_and_next_links(publication, edition)
    siblings = {}

    if publication.has_previous_part?
      siblings.merge!(
        previous_page: {
          "title" => t('formats.guide.navigate_to_previous_part'),
          "url" => previous_part_path(publication, publication.current_part, edition),
          "label" => publication.part_before(publication.current_part).title
        }
      )
    end

    if publication.has_next_part?
      siblings.merge!(
        next_page: {
          "title" => t('formats.guide.navigate_to_next_part'),
          "url" => next_part_path(publication, publication.current_part, edition),
          "label" => publication.part_after(publication.current_part).title
        }
      )
    end

    siblings
  end
end

module ApplicationHelper
  def page_title(publication, artefact, video_mode = false)
    ''.tap do |title|
      if video_mode
        title << 'Video - '
      end

      if publication.alternative_title.blank?
        title << publication.title
      else
        title << publication.alternative_title
      end

      title << ' | '

      unless artefact.section.blank?
        title << artefact.section
        title << ' | '
      end

      title << 'www.gov.uk'
    end
  end

  def body_wrapper_class(publication = nil, video_mode = false)
    if publication and video_mode
      publication.type + ' video-guide'
    elsif publication
      publication.type
    end
  end
end

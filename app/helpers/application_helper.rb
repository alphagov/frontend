module ApplicationHelper
  def assemble_publication_title(publication)
    return '' if publication.nil?

    title = ''
    if publication and publication.alternative_title.blank?
      title << publication.title
    elsif publication
      title << publication.alternative_title
    end
    title << ' | '
    title
  end

  def page_title(artefact, publication = nil, video_mode = false)
    ''.tap do |title|
      title << 'Video - ' if video_mode
      title << assemble_publication_title(publication) if publication

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
    else
      ''
    end
  end
end

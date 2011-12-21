module ApplicationHelper

  def page_title(artefact, publication=nil)
    if publication
      title = [publication.alternative_title, publication.title].find(&:present?)
      title = "Video - #{title}" if request.format.video?
    end

    [title, artefact.section, 'www.gov.uk'].select(&:present?).join(" | ")
  end

  def wrapper_class(publication = nil)
    if publication and request.format.video?
      publication.type + ' video-guide'
    elsif publication
      publication.type
    else
      ''
    end
  end
end

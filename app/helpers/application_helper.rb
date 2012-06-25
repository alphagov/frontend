module ApplicationHelper

  def page_title(artefact, publication=nil)
    if publication
      title = [publication.title, publication.alternative_title].find(&:present?)
      title = "Video - #{title}" if request.format.video?
    end

    [title, artefact.section && artefact.section.split(':').first, 'GOV.UK Beta (Test)'].select(&:present?).join(" | ")
  end

  def wrapper_class(publication = nil, artefact = nil)
    services = %W[transaction local_transaction place]
    html_classes = []

    if publication
      if publication.type
        html_classes << publication.type
      end

      if request.format.video?
        html_classes << "video-guide"
      end

      if services.include? publication.type
        html_classes << "service"
      end
    elsif action_name == "settings" and request.format.html?
      html_classes << "settings"
    end

    if artefact
      if artefact.business_proposition
        html_classes << "business"
      end
    end

    html_classes.join(' ')
  end

  def section_meta_tags(artefact)
    return '' if artefact.nil? or artefact.section.blank?
    section = artefact.section.split(':').first
    tag(:meta, {name: 'x-section-name', content: section}, true) +
      tag(:meta, {name: 'x-section-link', content: "/browse/#{section.parameterize}"}, true) +
      tag(:meta, {name: 'x-section-format', content: artefact.kind}, true)
  end
end

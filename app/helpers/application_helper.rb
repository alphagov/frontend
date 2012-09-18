require "#{Rails.root}/lib/artefact_helpers"

module ApplicationHelper
  include ArtefactHelpers

  def page_title(artefact, publication=nil)
    if publication
      title = [publication.title, publication.alternative_title].find(&:present?)
      title = "Video - #{title}" if request.format.video?
    end
    if root_primary_section = root_primary_section(artefact)
      root_primary_section_title = root_primary_section["title"]
    else
      root_primary_section_title = nil
    end
    [title, root_primary_section_title, 'GOV.UK Beta (Test)'].select(&:present?).join(" | ")
  end

  def wrapper_class(publication = nil, artefact = nil)
    services = %W[transaction local_transaction completed_transaction place]
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

    html_classes.join(' ')
  end
end

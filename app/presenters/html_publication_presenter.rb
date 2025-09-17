class HtmlPublicationPresenter < ContentItemPresenter
  include ContentsList
  include DateHelper

  def hide_from_search_engines?
    return false unless content_item.parent

    PublicationPresenter::PATHS_TO_HIDE.include? content_item.parent.base_path
  end

  def organisation_logos
    content_item.organisations.map do |organisation|
      {
        name: organisation.logo.formatted_title.html_safe,
        url: organisation.base_path,
        brand: organisation.brand,
        crest: organisation.logo.crest,
        image: content_item.organisations.count == 1 ? organisation.logo.image : nil,
      }
    end
  end

  def last_changed
    timestamp = display_date(content_item.public_timestamp)

    # This assumes that a translation doesn't need the date to come beforehand.
    if content_item.first_published_version
      "#{I18n.t('common.metadata.published')} #{timestamp}"
    else
      "#{I18n.t('common.metadata.updated')} #{timestamp}"
    end
  end

  def format_sub_type
    if content_item.parent && content_item.parent.document_type.present?
      content_item.parent.document_type
    else
      "publication"
    end
  end

  def full_path(request)
    request.base_url + request.path
  end
end

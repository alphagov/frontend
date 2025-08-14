class HtmlPublicationPresenter < ContentItemPresenter
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
end

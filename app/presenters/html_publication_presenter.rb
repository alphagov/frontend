class HtmlPublicationPresenter < ContentItemPresenter
  include OrganisationBranding

  def hide_from_search_engines?
    return false unless content_item.parent

    PublicationPresenter::PATHS_TO_HIDE.include? content_item.parent.base_path
  end

  # def organisation_logo(organisation)
  #   organisation_logo.tap do |logo|
  #     if logo && organisations.count > 1
  #       logo[:organisation].delete(:image)
  #     end
  #   end
  # end
end

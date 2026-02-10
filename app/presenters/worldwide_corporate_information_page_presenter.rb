class WorldwideCorporateInformationPagePresenter < ContentItemPresenter
  include WorldwideOrganisationBranding
  
  def worldwide_organisation
    return unless content_item.worldwide_organisation

    WorldwideOrganisationPresenter.new(content_item.worldwide_organisation)
  end
end

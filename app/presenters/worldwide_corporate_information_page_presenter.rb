class WorldwideCorporateInformationPagePresenter < ContentItemPresenter
  include WorldwideOrganisationBranding
  include ContentsList

  def page_title_options
    super.merge({
      organisation_logo: worldwide_organisation.organisation_logo,
    })
  end

  def worldwide_organisation
    return unless content_item.worldwide_organisation

    WorldwideOrganisationPresenter.new(content_item.worldwide_organisation)
  end
end

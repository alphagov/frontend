class WorldwideCorporateInformationPagePresenter < ContentItemPresenter
  include WorldwideOrganisationBranding
  include ContentsList

  def page_title_options
    super.merge({
      organisation_logo: worldwide_organisation.organisation_logo,
      organisation_logo_heading_level: 1,
      heading_level: 2,
      world_location_links: worldwide_organisation.world_location_links,
      sponsoring_organisation_links: worldwide_organisation.sponsoring_organisation_links,
    })
  end

  def worldwide_organisation
    return unless content_item.worldwide_organisation

    WorldwideOrganisationPresenter.new(content_item.worldwide_organisation)
  end
end

class WorldwideOfficePresenter < ContentItemPresenter
  include WorldwideOrganisationBranding
  include ContentsList

  def page_title_options
    super.merge({
      organisation_logo: worldwide_organisation.organisation_logo,
      organisation_logo_heading_level: 1,
      heading_level: 2,
      heading_text: ActionController::Base.helpers.sanitize("<span class='govuk-visually-hidden'>About </span> #{content_item.title}"),
    })
  end

  def body
    content_item.content_store_response["details"]["access_and_opening_times"]
  end

  def contact
    LinkedContactPresenter.new(content_item.contact.content_store_response)
  end

  def worldwide_organisation
    return unless content_item.worldwide_organisation

    WorldwideOrganisationPresenter.new(content_item.worldwide_organisation)
  end
end

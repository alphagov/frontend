class WorldwideOfficePresenter < ContentItemPresenter
  include ContentsList
  include WorldwideOrganisationBranding

  def formatted_title
    worldwide_organisation&.formatted_title
  end

  def body
    content_item.dig("details", "access_and_opening_times")
  end

  def contact
    LinkedContactPresenter.new(content_item.contact)
  end

  def show_default_breadcrumbs?
    false
  end

  def worldwide_organisation
    return unless content_item.worldwide_organisation

    WorldwideOrganisationPresenter.new(content_item.worldwide_organisation)
  end

  def sponsoring_organisations
    worldwide_organisation&.sponsoring_organisations
  end

private

  def show_contents_list?
    true
  end
end

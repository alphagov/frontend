class WorldwideOfficePresenter < ContentItemPresenter
  include WorldwideOrganisationBranding
  include ContentsList

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

private

  def show_contents_list?
    true
  end
end

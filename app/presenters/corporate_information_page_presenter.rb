class CorporateInformationPagePresenter < ContentItemPresenter
  def page_title
    page_title = super
    page_title += " - #{default_organisation['title']}" if default_organisation
    page_title
  end

private

  def default_organisation
    organisation_content_id = content_item.content_store_hash.dig("details", "organisation")
    organisation = nil
    if organisations.present?
      organisation = organisations.detect { |org| org["content_id"] == organisation_content_id }
      raise "No organisation in links that matches the one specified in details: #{organisation_content_id}" unless organisation
    end

    organisation
  end

  def organisations
    content_item.content_store_response.dig("links", "organisations") || []
  end
end

class CorporateInformationPage < ContentItem
  def default_organisation
    organisation_content_id = content_store_response.dig("details", "organisation")

    @default_organisation ||= organisations.detect { |org| org.content_id == organisation_content_id }
  end
end

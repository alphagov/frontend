class CorporateInformationPage < ContentItem
  def organisation_brand_class
    return unless default_organisation

    "#{default_organisation.brand}-brand-colour"
  end

  def default_organisation
    return if organisations.blank?

    organisation_content_id = content_store_response.dig("details", "organisation")

    @default_organisation ||= organisations.detect { |org| org.content_id == organisation_content_id }
  end
end

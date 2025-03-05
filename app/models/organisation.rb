class Organisation < ContentItem
  attr_reader :logo

  def initialize(organisation_data)
    super(organisation_data)
    @logo = OrganisationLogo.new(organisation_data.dig("details", "logo"), base_path)
    @organisation_data = organisation_data
  end

  def brand
    organisation_data.dig("details", "brand")
  end

private

  attr_reader :organisation_data
end

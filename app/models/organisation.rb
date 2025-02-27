class Organisation < ContentItem
  attr_reader :logo

  def initialize(organisation_data)
    @logo = Logo.new(organisation_data.dig("details", "logo"))
    @organisation_data = organisation_data
  end

  def brand
    organisation_data.dig("details", "brand")
  end

private

  attr_reader :organisation_data
end

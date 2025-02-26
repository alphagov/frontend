class Organisation < ContentItem
  attr_reader :logo

  def initialize(organisation_data)
    @logo = Logo.new(organisation_data.dig("details", "logo"))
  end
end

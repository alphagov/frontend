class LocalTransaction < ContentItem
  attr_reader :country_name, :introduction, :more_information, :need_to_know

  def initialize(content_store_response)
    super(content_store_response)

    @introduction = content_store_response.dig("details", "introduction")
    @more_information = content_store_response.dig("details", "more_information")
    @need_to_know = content_store_response.dig("details", "need_to_know")
  end

  def unavailable?
    country_name_availability_for("type") == "unavailable"
  end

  def devolved_administration_service?
    country_name_availability_for("type") == "devolved_administration_service"
  end

  def devolved_administration_service_alternative_url
    return unless devolved_administration_service?

    country_name_availability_for("alternative_url")
  end

  def set_country(country_name)
    @country_name = country_name.downcase.gsub(" ", "_")
  end

private

  def country_name_availability_for(key)
    content_store_response.dig("details", country_name_availability, key)
  end

  def country_name_availability
    "#{country_name}_availability"
  end
end

class LocalTransaction < ContentItem
  attr_reader :country_name, :introduction,
              :lgil_code, :lgil_override, :lgsl_code,
              :more_information, :need_to_know

  def initialize(content_store_response)
    super(content_store_response)

    @introduction = content_store_response.dig("details", "introduction")
    @lgil_code = content_store_response.dig("details", "lgil_code")
    @lgil_override = content_store_response.dig("details", "lgil_override")
    @lgsl_code = content_store_response.dig("details", "lgsl_code")
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

  def slug
    URI.parse(base_path).path.sub(%r{\A/}, "")
  end

  # the apply to foster page has a few hard-coded exceptions to its
  # layout, so add a method to detect it.
  def apply_foster_child_council?
    slug == "apply-foster-child-council"
  end

private

  def country_name_availability_for(key)
    content_store_response.dig("details", country_name_availability, key)
  end

  def country_name_availability
    "#{country_name}_availability"
  end
end

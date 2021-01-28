require "singleton"

class LocalTransactionServices
  include Singleton

  def initialize
    yaml_file_path = if Rails.env.test?
                       "test/fixtures/unavailable_services.yml"
                     else
                       "config/unavailable_services.yml"
                     end
    @config = YAML.safe_load(File.open(Rails.root.join(yaml_file_path)))
  end

  def unavailable?(lgsl, country_name)
    @config.dig("services", lgsl).present? && @config.dig("services", lgsl, "countries", "unavailable_in").include?(country_name)
  end

  def content(lgsl, country_name, local_authority_name)
    content = @config.dig("services", lgsl, "countries", "content")

    return "" unless content

    I18n.interpolate(
      content,
      country_name: country_name,
      local_authority_name: local_authority_name,
    ) || ""
  end
end

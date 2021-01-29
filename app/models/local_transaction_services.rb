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
    @config.dig("services", lgsl, country_name).present?
  end

  def content(lgsl, country_name, params = {})
    content = @config.dig("services", lgsl, country_name)
    return "" unless content

    params.blank? ? content : I18n.interpolate(content, params)
  end
end

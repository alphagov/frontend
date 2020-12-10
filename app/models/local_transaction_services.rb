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
    @config.dig("services", lgsl).present? && @config.dig("services", lgsl).include?(country_name)
  end
end

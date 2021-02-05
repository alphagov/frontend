class LocalTransactionService
  def self.config
    @config ||= begin
      filepath = Rails.root.join(Frontend.local_transactions_config)
      YAML.safe_load(File.open(filepath))["services"]
    end
  end

  attr_reader :lgsl

  def initialize(name, lgsl, country_name, local_authority_homepage)
    @name = name
    @lgsl = lgsl
    @country_name = country_name
    @local_authority_homepage = local_authority_homepage

    @unavailable_content = LocalTransactionService.config.dig(
      lgsl, "unavailable_in", @country_name
    ) || {}
  end

  def body
    @unavailable_content["body"]
  end

  def button_text
    @unavailable_content["button_text"] || "Find other services"
  end

  def button_link
    @unavailable_content["button_link"] || @local_authority_homepage
  end

  def title
    @unavailable_content["title"] || @name
  end

  def unavailable?
    @unavailable_content.present?
  end
end

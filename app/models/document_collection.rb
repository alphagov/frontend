class DocumentCollection < ContentItem
  include Political
  include SinglePageNotificationButton
  include Updatable

  attr_reader :headers

  def initialize(content_store_response)
    super

    @headers = content_store_response.dig("details", "headers") || []
  end

  def taxonomy_topic_email_override_base_path
    linked("taxonomy_topic_email_override").first&.base_path
  end
end

class LicenceTransaction < ContentItem
  attr_reader :body,
              :licence_transaction_continuation_link,
              :licence_transaction_licence_identifier,
              :licence_transaction_will_continue_on

  def initialize(content_store_response)
    super

    @body = content_store_response.dig("details", "body")
    @licence_transaction_continuation_link = content_store_response.dig("details", "metadata", "licence_transaction_continuation_link")
    @licence_transaction_licence_identifier = content_store_response.dig("details", "metadata", "licence_transaction_licence_identifier")
    @licence_transaction_will_continue_on = content_store_response.dig("details", "metadata", "licence_transaction_will_continue_on")
  end

  def slug
    URI.parse(base_path).path.split("/").last
  end
end

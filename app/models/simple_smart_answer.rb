class SimpleSmartAnswer < ContentItem
  attr_reader :body, :nodes, :start_button_text

  def initialize(content_store_response)
    super

    @body = content_store_response.dig("details", "body")
    @nodes = content_store_response.dig("details", "nodes")
    @start_button_text = content_store_response.dig("details", "start_button_text")
  end

  def slug
    @slug = URI.parse(@base_path).path.sub(%r{\A/}, "")
  end
end

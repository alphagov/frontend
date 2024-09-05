class ContentItem
  attr_reader :content_store_response, :body, :image, :description, :document_type, :title, :base_path, :locale

  def initialize(content_store_response)
    @content_store_response = content_store_response
    @body = content_store_response.dig("details", "body")
    @image = content_store_response.dig("details", "image")
    @description = content_store_response["description"]
    @document_type = content_store_response["document_type"]
    @title = content_store_response["title"]
    @base_path = content_store_response["base_path"]
    @locale = content_store_response["locale"]
  end

  delegate :to_h, to: :content_store_response
  delegate :cache_control, to: :content_store_response
end

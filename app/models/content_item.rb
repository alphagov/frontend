class ContentItem
  attr_reader :content_store_response, :content_store_hash, :body, :image, :description, :document_type, :title, :base_path, :locale

  # SCAFFOLDING: remove the override_content_store_hash parameter when full landing page
  # content items including block details are available from content-store
  def initialize(content_store_response, override_content_store_hash: nil)
    @content_store_response = content_store_response
    @content_store_hash = override_content_store_hash || content_store_response.to_hash

    @body = content_store_hash.dig("details", "body")
    @image = content_store_hash.dig("details", "image")
    @description = content_store_hash["description"]
    @document_type = content_store_hash["document_type"]
    @title = content_store_hash["title"]
    @base_path = content_store_hash["base_path"]
    @locale = content_store_hash["locale"]
  end

  alias_method :to_h, :content_store_hash
  delegate :cache_control, to: :content_store_response
end

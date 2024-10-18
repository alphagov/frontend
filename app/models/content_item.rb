class ContentItem
  attr_reader :content_store_response, :content_store_hash, :body, :image, :description,
              :document_type, :schema_name, :title, :base_path, :locale

  # SCAFFOLDING: remove the override_content_store_hash parameter when full landing page
  # content items including block details are available from content-store
  def initialize(content_store_response, override_content_store_hash: nil)
    @content_store_response = content_store_response
    @content_store_hash = override_content_store_hash || content_store_response.to_hash

    @body = content_store_hash.dig("details", "body")
    @image = content_store_hash.dig("details", "image")
    @description = content_store_hash["description"]
    @document_type = content_store_hash["document_type"]
    @schema_name = content_store_hash["schema_name"]
    @title = content_store_hash["title"]
    @base_path = content_store_hash["base_path"]
    @locale = content_store_hash["locale"]
  end

  alias_method :to_h, :content_store_hash
  delegate :cache_control, to: :content_store_response

  REGEX_IS_A = /is_an?_(.*)\?/

  def respond_to_missing?(method_name, _include_private = false)
    method_name.to_s =~ REGEX_IS_A ? true : super
  end

  def method_missing(method_name, *_args, &_block)
    if method_name.to_s =~ REGEX_IS_A
      schema_name == ::Regexp.last_match(1)
    else
      super
    end
  end
end

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

    content_store_hash["links"]["ordered_related_items"] = ordered_related_items(content_store_hash["links"]) if content_store_hash["links"]
  end

  alias_method :to_h, :content_store_hash
  delegate :cache_control, to: :content_store_response

  def available_translations
    translations = content_store_response["links"]["available_translations"] || []

    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? "" : t["locale"] }
  end

private

  def ordered_related_items(links)
    return [] if links["ordered_related_items_overrides"].present?

    links["ordered_related_items"].presence || links.fetch(
      "suggested_ordered_related_items", []
    )
  end
end

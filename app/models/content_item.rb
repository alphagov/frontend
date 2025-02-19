require "ostruct"

class ContentItem
  include Withdrawable
  attr_reader :attachments, :base_path, :body, :content_store_hash,
              :content_store_response, :description, :document_type, :first_public_at,
              :first_published_at, :image, :links, :locale, :phase, :public_updated_at,
              :schema_name, :title

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
    @public_updated_at = content_store_hash["public_updated_at"]
    @links = content_store_hash["links"]
    @phase = content_store_hash["phase"]
    @first_published_at = content_store_hash["first_published_at"]
    @first_public_at = content_store_hash.dig("details", "first_public_at")

    @attachments = get_attachments(content_store_hash.dig("details", "attachments"))

    content_store_hash["links"]["ordered_related_items"] = ordered_related_items(content_store_hash["links"]) if content_store_hash["links"]
  end

  alias_method :to_h, :content_store_hash
  delegate :cache_control, to: :content_store_response

  REGEX_IS_A = /is_an?_(.*)\?/

  def organisations
    linked("organisations")
  end

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

  def available_translations
    translations = content_store_response["links"]["available_translations"] || []

    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? "" : t["locale"] }
  end

  def meta_section
    @meta_section ||= content_store_hash.dig(
      "links", "parent", 0, "links", "parent", 0, "title"
    )&.downcase
  end

  def contributors
    organisations.map { |org| { "title" => org.title, "base_path" => org.base_path } }
  end

private

  def linked(type)
    content_store_hash.dig("links", type).map { |hash| ContentItemFactory.build(hash) }
  end

  def get_attachments(attachment_hash)
    return [] unless attachment_hash

    attachment_hash.map { OpenStruct.new(_1) }
  end

  def ordered_related_items(links)
    return [] if links["ordered_related_items_overrides"].present?

    links["ordered_related_items"].presence || links.fetch(
      "suggested_ordered_related_items", []
    )
  end
end

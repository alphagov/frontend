require "ostruct"

class ContentItem
  include Withdrawable
  attr_reader :base_path, :body, :content_id,
              :content_store_response, :description, :document_type, :first_public_at,
              :first_published_at, :image, :links, :locale, :phase, :public_updated_at,
              :schema_name, :title

  def initialize(content_store_response)
    @content_store_response = content_store_response

    @body = content_store_response.dig("details", "body")
    @content_id = content_store_response["content_id"]
    @image = content_store_response.dig("details", "image")
    @description = content_store_response["description"]
    @document_type = content_store_response["document_type"]
    @schema_name = content_store_response["schema_name"]
    @title = content_store_response["title"]
    @base_path = content_store_response["base_path"]
    @locale = content_store_response["locale"]
    @public_updated_at = content_store_response["public_updated_at"]
    @links = content_store_response["links"]
    @phase = content_store_response["phase"]
    @first_published_at = content_store_response["first_published_at"]
    @first_public_at = content_store_response.dig("details", "first_public_at")

    content_store_response["links"]["ordered_related_items"] = ordered_related_items(content_store_response["links"]) if content_store_response["links"]
  end

  alias_method :to_h, :content_store_response

  REGEX_IS_A = /is_an?_(.*)\?/

  def organisations
    linked("organisations")
  end
  alias_method :contributors, :organisations

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

  def available_translations?
    available_translations.length > 1
  end

  def available_translations
    translations = content_store_response["links"]["available_translations"] || []

    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? "" : t["locale"] }
  end

  def meta_section
    @meta_section ||= content_store_response.dig(
      "links", "parent", 0, "links", "parent", 0, "title"
    )&.downcase
  end

private

  def linked(type)
    return [] if content_store_response.dig("links", type).blank?

    content_store_response.dig("links", type).map { |hash| ContentItemFactory.build(hash) }
  end

  def ordered_related_items(links)
    return [] if links["ordered_related_items_overrides"].present?

    links["ordered_related_items"].presence || links.fetch(
      "suggested_ordered_related_items", []
    )
  end
end

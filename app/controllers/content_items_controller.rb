class ContentItemsController < ApplicationController
  before_action :set_locale, if: -> { request.format.html? }

protected

  helper_method :meta_section

  def meta_section(content_item_hash)
    @meta_section ||= content_item_hash.dig(
      "links", "parent", 0, "links", "parent", 0, "title"
    )&.downcase
  end

private

  def content_item
    loader_response = ContentItemLoader.for_request(request).load(content_item_path)
    raise loader_response if loader_response.is_a?(StandardError)

    @content_item ||= ContentItemFactory.build(loader_response)
  end

  def content_item_path
    request.path
  end

  def content_item_hash
    @content_item_hash ||= content_item.to_h
  end

  # NOTE: Frontend honours the max-age directive  provided
  # in Content Store's Cache-Control response header.
  def set_expiry(expiry = nil)
    if expiry
      expires_in(expiry, public: true)
      return
    end
    unless Rails.env.development?
      expires_in(
        content_item.cache_control.max_age,
        public: !content_item.cache_control.private?,
      )
    end
  end

  def set_locale
    I18n.locale = if content_item.locale && I18n.available_locales.map(&:to_s).include?(content_item.locale)
                    content_item.locale
                  else
                    I18n.default_locale
                  end
  end

  def deny_framing
    response.headers["X-Frame-Options"] = "DENY"
  end
end

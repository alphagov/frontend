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

  def publication
    @publication ||= publication_class.new(content_item_hash)
  end

  def publication_class
    ContentItemPresenter
  end

  def content_item
    @content_item ||= request.env[:content_item] || request_content_item(content_item_slug || "/#{params[:slug]}")
  end

  def content_item_slug
    nil # set to override content item fetched from Content Store
  end

  def content_item_hash
    @content_item_hash ||= content_item.to_h
  end

  def request_content_item(base_path = "/#{params[:slug]}")
    GdsApi.content_store.content_item(base_path)
  end

  def set_locale
    I18n.locale = if content_item["locale"] && I18n.available_locales.map(&:to_s).include?(content_item["locale"])
                    content_item["locale"]
                  else
                    I18n.default_locale
                  end
  end

  def deny_framing
    response.headers["X-Frame-Options"] = "DENY"
  end
end

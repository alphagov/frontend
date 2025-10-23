class ContentItemsController < ApplicationController
  include GovukPersonalisation::ControllerConcern

  before_action :set_content_item_and_cache_control
  before_action :reroute_to_gone, if: -> { content_item.schema_name == "gone" }

  attr_reader :content_item

  helper_method :logged_in?

private

  def set_content_item_and_cache_control
    loader_response = ContentItemLoader.for_request(request).load(content_item_path)
    raise loader_response if loader_response.is_a?(StandardError)

    @content_item = ContentItemFactory.build(loader_response.to_hash)
    @cache_control = loader_response.cache_control
  end

  def content_item_path
    request.path
  end

  def reroute_to_gone
    GoneController.dispatch(:show, request, response)
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
        @cache_control.max_age,
        public: !@cache_control.private?,
      )
    end
  end

  def deny_framing
    response.headers["X-Frame-Options"] = "DENY"
  end

  def set_account_vary_header
    # Override the default from GovukPersonalisation::ControllerConcern so pages are cached on each flash message
    # variation, rather than caching pages per user
    response.headers["Vary"] = [response.headers["Vary"], "GOVUK-Account-Session-Exists", "GOVUK-Account-Session-Flash"].compact.join(", ")
  end
end

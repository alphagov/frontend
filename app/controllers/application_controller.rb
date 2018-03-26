require 'gds_api/helpers'

class ApplicationController < ActionController::Base
  include GdsApi::Helpers
  include Slimmer::Headers
  include Slimmer::Template
  include Slimmer::GovukComponents

  rescue_from GdsApi::TimedOutException, with: :error_503
  rescue_from GdsApi::EndpointNotFound, with: :error_503
  rescue_from GdsApi::HTTPErrorResponse, with: :error_503
  rescue_from GdsApi::HTTPGone, with: :error_410
  rescue_from GdsApi::HTTPNotFound, with: :cacheable_404
  rescue_from GdsApi::InvalidUrl, with: :cacheable_404
  rescue_from RecordNotFound, with: :cacheable_404

  slimmer_template 'wrapper'

protected

  def error_410; error :gone; end

  def error_503(e); error(:service_unavailable, e); end

  def error(status_code, exception = nil)
    if exception
      GovukError.notify(exception)
    end

    head(status_code)
  end

  def cacheable_404
    set_expiry(10.minutes)
    error :not_found
  end

  def set_expiry(duration = 30.minutes)
    unless Rails.env.development?
      expires_in(duration, public: true)
    end
  end

  def setup_content_item(base_path)
    begin
      @content_item = content_store.content_item(base_path).to_hash
      section_name = @content_item.dig("links", "parent", 0, "links", "parent", 0, "title")
      if section_name
        @meta_section = section_name.downcase
      end
    rescue GdsApi::HTTPNotFound, GdsApi::HTTPGone
      @content_item = nil
      @meta_section = nil
    end
  end

  def set_content_item(presenter = ContentItemPresenter)
    @publication = presenter.new(content_item)
    set_language_from_publication
  end

  def set_language_from_publication
    I18n.locale = if @publication.locale && I18n.available_locales.map(&:to_s).include?(@publication.locale)
                    @publication.locale
                  else
                    I18n.default_locale
                  end
  end

  def content_item
    @_content_item ||= Services.content_store.content_item("/#{params[:slug]}")
  end

private

  def default_url_options
    {}.merge(token)
      .merge(cache)
  end

  def token
    params[:token] ? { token: params[:token] } : {}
  end

  def cache
    params[:cache] ? { cache: params[:cache] } : {}
  end
end

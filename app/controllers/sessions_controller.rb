class SessionsController < ApplicationController
  include GovukPersonalisation::ControllerConcern

  before_action :set_no_cache_headers

  def create
    redirect_path = http_referer_path
    redirect_path = nil unless is_valid_redirect_path? redirect_path

    redirect_with_analytics GdsApi.account_api.get_sign_in_url(redirect_path: redirect_path)["auth_uri"]
  end

  def callback
    redirect_to Plek.new.website_root and return unless params[:code] && params[:state]

    callback = GdsApi.account_api.validate_auth_response(
      code: params.require(:code),
      state: params.require(:state),
    )

    ga_client_id = callback["ga_client_id"] || params[:_ga]
    cookie_consent =
      case callback["cookie_consent"]
      when true
        "accept"
      when false
        "reject"
      else
        params[:cookie_consent]
      end

    set_account_session_header(callback["govuk_account_session"])

    redirect_to GovukPersonalisation::Redirect.build_url(callback["redirect_path"] || account_home_path, { _ga: ga_client_id, cookie_consent: cookie_consent }.compact)
  rescue GdsApi::HTTPUnauthorized
    head :bad_request
  end

  def delete
    logout!
    if params[:continue]
      # TODO: remove this case when we have migrated to DI in production
      redirect_with_analytics "#{Plek.find('account-manager')}/sign-out?done=#{params[:continue]}"
    elsif params[:done]
      # TODO: remove this case when we have migrated to DI in production
      redirect_with_analytics Plek.new.website_root
    else
      redirect_with_analytics GdsApi.account_api.get_end_session_url(govuk_account_session: account_session_header)["end_session_uri"]
    end
  end

protected

  def http_referer_path
    @http_referer_path ||=
      begin
        http_referer = request.headers["HTTP_REFERER"]

        if http_referer&.start_with?(Plek.new.website_root)
          http_referer.delete_prefix Plek.new.website_root
        end
      end
  end

  def is_valid_redirect_path?(value)
    return true if value.blank?
    return false if value.starts_with? "//"
    return true if value.starts_with? "/"
    return true if value.starts_with?("http://") && Rails.env.development?

    false
  end
end

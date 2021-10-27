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
    ).to_h

    @cookie_consent =
      case params[:cookie_consent]
      when "accept"
        update_saved_cookie_consent = !callback["cookie_consent"]
        "accept"
      when "reject"
        update_saved_cookie_consent = callback["cookie_consent"]
        "reject"
      else
        update_saved_cookie_consent = false
        callback["cookie_consent"] ? "accept" : "reject"
      end

    # TODO: remove callback["ga_client_id"] when we have switched to
    # Digital Identity in production
    if callback.key?("cookie_consent") && callback.key?("feedback_consent") && (callback["cookie_consent"].nil? || callback["feedback_consent"].nil?)
      @ga_client_id = callback["ga_client_id"]
      @redirect_path = callback["redirect_path"]
      @govuk_account_session = callback["govuk_account_session"]
      render :first_time
    else
      do_login(
        redirect_path: callback["redirect_path"],
        cookie_consent: @cookie_consent,
        update_saved_cookie_consent: update_saved_cookie_consent,
        govuk_account_session: callback["govuk_account_session"],
        ga_client_id: callback["ga_client_id"],
      )
    end
  rescue GdsApi::HTTPUnauthorized
    head :bad_request
  end

  def first_time
    set_slimmer_headers(template: "gem_layout_account_manager_no_nav", remove_search: true, show_accounts: "signed-in")
    redirect_path = params[:redirect_path]
    head :bad_request unless is_valid_redirect_path? redirect_path

    govuk_account_session = params.fetch(:govuk_account_session)

    @error_items = []
    unless %w[yes no].include? params[:cookie_consent]
      @cookie_consent_decision_error = I18n.t("sessions.first_time.cookie_consent.field.invalid")
      @error_items << { field: "cookie_consent", href: "#cookie_consent", text: @cookie_consent_decision_error }
    end
    unless %w[yes no].include? params[:feedback_consent]
      @feedback_consent_decision_error = I18n.t("sessions.first_time.feedback_consent.field.invalid")
      @error_items << { field: "feedback_consent", href: "#feedback_consent", text: @feedback_consent_decision_error }
    end

    if @error_items.empty?
      cookie_consent_decision = params[:cookie_consent] == "yes"
      feedback_consent_decision = params[:feedback_consent] == "yes"

      response = GdsApi.account_api.set_attributes(
        attributes: {
          cookie_consent: cookie_consent_decision,
          feedback_consent: feedback_consent_decision,
        },
        govuk_account_session: govuk_account_session,
      )

      do_login(
        redirect_path: redirect_path,
        cookie_consent: cookie_consent_decision ? "accept" : "reject",
        update_saved_cookie_consent: false,
        govuk_account_session: response["govuk_account_session"],
      )
    end
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

  def do_login(redirect_path:, cookie_consent:, update_saved_cookie_consent:, govuk_account_session:, ga_client_id: nil)
    set_account_session_header(govuk_account_session)

    if update_saved_cookie_consent
      GdsApi.account_api.set_attributes(
        attributes: { cookie_consent: cookie_consent == "accept" },
        govuk_account_session: account_session_header,
      )
    end

    redirect_to GovukPersonalisation::Redirect.build_url(
      redirect_path || account_home_path,
      {
        _ga: ga_client_id || params[:_ga],
        cookie_consent: cookie_consent,
      }.compact,
    )
  end
end

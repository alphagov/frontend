class SessionsController < ApplicationController
  include GovukPersonalisation::ControllerConcern

  before_action :set_no_cache_headers
  before_action :set_up_first_time, only: %i[first_time first_time_post]

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

    cookie_consent =
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

    if callback.key?("cookie_consent") && callback.key?("feedback_consent") && (callback["cookie_consent"].nil? || callback["feedback_consent"].nil?)
      # slightly hacky way of passing the session header along in the
      # redirect without properly logging the user in: prefix it with
      # "!" so the header isn't actually correct
      set_account_session_header "!#{callback['govuk_account_session']}"

      redirect_to GovukPersonalisation::Redirect.build_url(
        new_govuk_session_first_time_path,
        { _ga: params[:_ga], cookie_consent: cookie_consent, redirect_path: callback["redirect_path"] ? CGI.escape(callback["redirect_path"]) : nil }.compact,
      )
    else
      do_login(
        redirect_path: callback["redirect_path"],
        cookie_consent: cookie_consent,
        update_saved_cookie_consent: update_saved_cookie_consent,
        govuk_account_session: callback["govuk_account_session"],
      )
    end
  rescue GdsApi::HTTPUnauthorized
    head :bad_request
  end

  def first_time; end

  def first_time_post
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
        govuk_account_session: @unprefixed_govuk_account_session,
      )

      do_login(
        redirect_path: params[:redirect_path],
        cookie_consent: cookie_consent_decision ? "accept" : "reject",
        update_saved_cookie_consent: false,
        govuk_account_session: response["govuk_account_session"],
      )
    else
      render :first_time
    end
  rescue GdsApi::HTTPUnauthorized
    head :bad_request
  end

  def delete
    logout!
    redirect_with_analytics GdsApi.account_api.get_end_session_url(govuk_account_session: account_session_header)["end_session_uri"]
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

  def do_login(redirect_path:, cookie_consent:, update_saved_cookie_consent:, govuk_account_session:)
    set_account_session_header(govuk_account_session)

    if update_saved_cookie_consent
      GdsApi.account_api.set_attributes(
        attributes: { cookie_consent: cookie_consent == "accept" },
        govuk_account_session: account_session_header,
      )
    end

    redirect_to GovukPersonalisation::Redirect.build_url(
      redirect_path.presence || account_home_path,
      {
        _ga: params[:_ga].presence,
        cookie_consent: cookie_consent,
      }.compact,
    )
  end

  def set_up_first_time
    head :bad_request and return unless is_valid_redirect_path? params[:redirect_path]
    head :bad_request and return unless account_session_header&.start_with? "!"

    @prefixed_govuk_account_session = account_session_header
    @unprefixed_govuk_account_session = @prefixed_govuk_account_session.delete_prefix("!")

    set_slimmer_headers(template: "gem_layout_account_manager_no_nav", remove_search: true, show_accounts: "signed-in")
  end
end

# frozen_string_literal: true

module AccountConcern
  extend ActiveSupport::Concern

  ACCOUNT_SESSION_REQUEST_HEADER_NAME = "HTTP_GOVUK_ACCOUNT_SESSION"
  ACCOUNT_SESSION_RESPONSE_HEADER_NAME = "GOVUK-Account-Session"
  ACCOUNT_END_SESSION_RESPONSE_HEADER_NAME = "GOVUK-Account-End-Session"
  ACCOUNT_SESSION_DEV_COOKIE_NAME = "govuk_account_session"

  included do
    before_action :fetch_account_session_header
    helper_method :logged_in?

    attr_accessor :account_session_header
  end

  def logged_in?
    account_session_header.present?
  end

  def fetch_account_session_header
    @account_session_header =
      if request.headers[ACCOUNT_SESSION_REQUEST_HEADER_NAME]
        request.headers[ACCOUNT_SESSION_REQUEST_HEADER_NAME]
      elsif Rails.env.development?
        cookies[ACCOUNT_SESSION_DEV_COOKIE_NAME]
      end
  end

  def set_account_session_header(govuk_account_session = nil)
    @account_session_header = govuk_account_session if govuk_account_session
    response.headers[ACCOUNT_SESSION_RESPONSE_HEADER_NAME] = @account_session_header

    if Rails.env.development?
      cookies[ACCOUNT_SESSION_DEV_COOKIE_NAME] = {
        value: @account_session_header,
        domain: "dev.gov.uk",
      }
    end
  end

  def logout!
    response.headers[ACCOUNT_END_SESSION_RESPONSE_HEADER_NAME] = "1"
    @account_session_header = nil

    if Rails.env.development?
      cookies[ACCOUNT_SESSION_DEV_COOKIE_NAME] = {
        value: "",
        domain: "dev.gov.uk",
        expires: 1.second.ago,
      }
    end
  end
end

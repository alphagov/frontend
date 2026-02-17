module Personalisable
  extend ActiveSupport::Concern
  include GovukPersonalisation::ControllerConcern

  def self.included(base)
    base.helper_method :logged_in?
  end

  def set_account_vary_header
    # Override the default from GovukPersonalisation::ControllerConcern so pages are cached on each flash message
    # variation, rather than caching pages per user
    response.headers["Vary"] = [response.headers["Vary"], "GOVUK-Account-Session-Exists", "GOVUK-Account-Session-Flash"].compact.join(", ")
  end
end

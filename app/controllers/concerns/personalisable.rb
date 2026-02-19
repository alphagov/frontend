module Personalisable
  extend ActiveSupport::Concern

  included do
    include GovukPersonalisation::ControllerConcern

    helper_method :logged_in?

    def set_account_vary_header
      # Override the default from GovukPersonalisation::ControllerConcern so pages are cached on each flash message
      # variation, rather than caching pages per user
      response.headers["Vary"] = [response.headers["Vary"], "GOVUK-Account-Session-Exists", "GOVUK-Account-Session-Flash"].compact.join(", ")
    end
  end
end

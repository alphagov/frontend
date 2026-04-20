if ENV["GOVUK_RAILS_JSON_LOGGING"].present?
  GovukJsonLogging.configure
end

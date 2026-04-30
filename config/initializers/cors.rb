# Be sure to restart your server when you modify this file.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # Allow the autocomplete API to be accessed from any GOV.UK domain, including non-production ones,
  # as well as Heroku preview apps. Note that the header is rendered on some arbitrary GOV.UK
  # subdomains (such as assets.publishing.service.gov.uk for CSV preview pages) so www alone is not
  # enough, and we may need autocomplete on local dev environments and Heroku preview apps as well.
  allow do
    origins %r{(\.gov\.uk|\.herokuapp.com)\z}

    resource "/api/search/autocomplete*",
             headers: :any,
             methods: %i[get]
  end
end

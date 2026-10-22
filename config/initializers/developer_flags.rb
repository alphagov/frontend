Rails.application.config.no_http_caching = (ENV["NO_HTTP_CACHING"] == "true") && Rails.env.development?

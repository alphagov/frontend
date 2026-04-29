Rails.application.config.allowed_geojson_slugs = ENV.fetch("ALLOWED_GEOJSON_SLUGS", "").split(",")

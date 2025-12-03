Rails.application.config.graphql_traffic_rates = ENV
  .select { |key, _| key.starts_with?("GRAPHQL_RATE_") }
  .transform_keys { |key| key.gsub(/^GRAPHQL_RATE_/, "").downcase }
  .transform_values(&:to_f)

Rails.application.config.graphql_allowed_schemas = Rails.application.config.graphql_traffic_rates.keys

require "gds_api/support_api"

support_api_token = ENV.fetch("SUPPORT_API_BEARER_TOKEN", "xxxxx")
Rails.application.config.support_api = GdsApi::SupportApi.new(Plek.find("support-api"), bearer_token: support_api_token)

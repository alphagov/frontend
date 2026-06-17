require "gds_api/content_store"
require "gds_api/search"

module Services
  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(
      Plek.new.find("content-store"),
      # Disable caching to avoid caching a stale max-age in the cache control
      # headers, which would cause this app to set the wrong max-age on its
      # own responses
      disable_cache: true,
    )
  end

  def self.search_api_v2
    GdsApi::SearchApiV2.new(Plek.find("search-api-v2"))
  end
end

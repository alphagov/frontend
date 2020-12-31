module CachedContentItem
  def self.fetch(base_path)
    Rails.cache.fetch("frontend_content_items_#{base_path}", expires_in: 30.seconds) do
      GovukStatsd.time("content_store.fetch_request_time") do
        GdsApi.content_store.content_item(base_path).to_h
      end
    end
  end
end

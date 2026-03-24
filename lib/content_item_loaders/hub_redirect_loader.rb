module ContentItemLoaders
  class HubRedirectLoader
    HUB_PATHS = {
      "/government/history" => "/government/history/history-of-the-uk-government",
    }.freeze

    def initialize(content_store_loader:)
      @content_store_loader = content_store_loader
    end

    def can_load?(request)
      HUB_PATHS.key?(request.path)
    end

    def load(request)
      base_path = request.path
      Rails.logger.debug("Loading content item #{base_path} from content address #{HUB_PATHS[base_path]}")
      content_store_loader.load_from_base_path(HUB_PATHS[base_path])
    end

  private

    attr_reader :content_store_loader
  end
end

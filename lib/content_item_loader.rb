require "ostruct"

class ContentItemLoader
  def self.for_request(request)
    request.env[:loader] ||= ContentItemLoader.new(request:)
  end

  attr_reader :alternative_loaders, :cache, :default_loader, :request

  def initialize(request: nil)
    @cache = {}
    @content_items_from_content_store = []
    @request = request
    @default_loader = ContentItemLoaders::ContentStoreLoader.new
    @alternative_loaders = [
      ContentItemLoaders::JsonFileLoader.new,
      ContentItemLoaders::YamlFileLoader.new,
      ContentItemLoaders::HubRedirectLoader.new(content_store_loader: default_loader),
      ContentItemLoaders::GraphqlLoader.new(content_store_loader: default_loader, request:),
    ]
  end

  def load(base_path)
    return GdsApi::InvalidUrl.new unless safe_path?(base_path)

    cache[base_path] ||= load_from_sources(base_path)
  end

private

  def load_from_sources(base_path)
    alternative_loaders.each do |loader|
      return loader.load(base_path:) if loader.can_load?(base_path:)
    end

    default_loader.load(base_path:)
  rescue ContentItemLoaders::UnableToLoad
    default_loader.load(base_path:)
  rescue GdsApi::HTTPErrorResponse, GdsApi::InvalidUrl => e
    e
  end

  def safe_path?(base_path)
    base_path == Pathname.new(base_path).expand_path.to_s
  end
end

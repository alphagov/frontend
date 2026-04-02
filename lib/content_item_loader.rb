require "ostruct"

class ContentItemLoader
  def self.for_request(request)
    request.env[:loader] ||= ContentItemLoader.new(request)
  end

  attr_reader :alternative_loaders, :cache, :default_loader, :request

  def initialize(request)
    @cache = {}
    @content_items_from_content_store = []
    @request = request
    @default_loader = ContentItemLoaders::ContentStoreLoader.new
    @alternative_loaders = [
      ContentItemLoaders::JsonFileLoader.new,
      ContentItemLoaders::YamlFileLoader.new,
      ContentItemLoaders::HubRedirectLoader.new(content_store_loader: default_loader),
    ]
  end

  def load(base_path)
    cache[base_path] ||= begin
      if base_path != request.path
        @request = duplicate_request_with_new_path(@request, base_path)
      end

      return GdsApi::InvalidUrl.new unless safe_path?(@request.path)

      load_from_sources(@request)
    end
  end

private

  def load_from_sources(request)
    alternative_loaders.each do |loader|
      return loader.load(request) if loader.can_load?(request)
    end

    default_loader.load(request)
  rescue ContentItemLoaders::UnableToLoad
    default_loader.load(request)
  rescue GdsApi::HTTPErrorResponse, GdsApi::InvalidUrl => e
    e
  end

  def safe_path?(base_path)
    base_path == Pathname.new(base_path).expand_path.to_s
  end

  def duplicate_request_with_new_path(request, new_path)
    new_env = request.env.dup

    new_env["PATH_INFO"] = new_path
    new_env["REQUEST_PATH"] = new_path
    new_env["ORIGINAL_FULLPATH"] = new_path

    ActionDispatch::Request.new(new_env)
  end
end

require "ostruct"

class ContentItemLoader
  LOCAL_ITEMS_PATH = "lib/data/local-content-items".freeze
  GRAPHQL_ALLOWED_SCHEMAS = %w[news_article].freeze

  def self.for_request(request)
    request.env[:loader] ||= ContentItemLoader.new(request:)
  end

  attr_reader :cache, :request

  def initialize(request: nil)
    @cache = {}
    @request = request
  end

  def load(base_path)
    cache[base_path] ||= load_from_sources(base_path)
  end

private

  def load_from_sources(base_path)
    if use_local_file? && File.exist?(yaml_filename(base_path))
      Rails.logger.debug("Loading content item #{base_path} from #{yaml_filename(base_path)}")
      load_yaml_file(base_path)
    elsif use_local_file? && File.exist?(json_filename(base_path))
      Rails.logger.debug("Loading content item #{base_path} from #{json_filename(base_path)}")
      load_json_file(base_path)
    elsif use_graphql?
      graphql_response = GdsApi.publishing_api.graphql_content_item(Graphql::EditionQuery.new(base_path).query)
      if GRAPHQL_ALLOWED_SCHEMAS.include?(graphql_response["schema"])
        graphql_response
      else
        GdsApi.content_store.content_item(base_path)
      end
    else
      GdsApi.content_store.content_item(base_path)
    end
  rescue GdsApi::HTTPErrorResponse, GdsApi::InvalidUrl => e
    e
  end

  def use_graphql?
    request&.params&.[]("graphql") == "true"
  end

  def use_local_file?
    ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] == "true"
  end

  def yaml_filename(base_path)
    Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.yml")
  end

  def load_yaml_file(base_path)
    GdsApi::Response.new(OpenStruct.new(code: 200, body: YAML.load(File.read(yaml_filename(base_path))).to_json, headers:))
  end

  def json_filename(base_path)
    Rails.root.join("#{LOCAL_ITEMS_PATH}#{base_path}.json")
  end

  def load_json_file(base_path)
    GdsApi::Response.new(OpenStruct.new(code: 200, body: File.read(json_filename(base_path)), headers:))
  end

  def headers
    { cache_control: "max-age=0, public", expires: "" }
  end
end

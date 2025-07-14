require "ostruct"

class ContentItemLoader
  include DraftHelper

  LOCAL_ITEMS_PATH = "lib/data/local-content-items".freeze
  GRAPHQL_ALLOWED_SCHEMAS = %w[news_article].freeze
  GRAPHQL_TRAFFIC_RATE = 0.5 # This is a decimal version of a percentage, so can be between 0 and 1

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
    else
      content_item = GdsApi.content_store.content_item(base_path)

      if use_graphql?(content_item["schema_name"])
        load_from_graphql(base_path) || content_item
      else
        content_item
      end
    end
  rescue GdsApi::HTTPErrorResponse, GdsApi::InvalidUrl => e
    e
  end

  def load_from_graphql(base_path)
    graphql_response = GdsApi.publishing_api.graphql_content_item(Graphql::EditionQuery.new(base_path).query)
    if graphql_response.to_hash.blank?
      set_prometheus_labels(graphql_contains_errors: true)
      nil
    else
      set_prometheus_labels
      graphql_response
    end
  rescue GdsApi::HTTPErrorResponse => e
    set_prometheus_labels(graphql_status_code: e.code)
    nil
  rescue GdsApi::TimedOutException
    set_prometheus_labels(graphql_api_timeout: true)
    nil
  end

  def use_graphql?(schema_name)
    return false unless request

    return false if draft_host?

    return false unless GRAPHQL_ALLOWED_SCHEMAS.include?(schema_name)

    if request.params["graphql"] == "true"
      return true
    elsif request.params["graphql"] == "false"
      return false
    end

    random_number = Random.rand(1.0)
    random_number < GRAPHQL_TRAFFIC_RATE
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

  def set_prometheus_labels(graphql_status_code: 200, graphql_contains_errors: false, graphql_api_timeout: false)
    prometheus_labels = request.env.fetch("govuk.prometheus_labels", {})

    hash = {
      "graphql_status_code" => graphql_status_code,
      "graphql_contains_errors" => graphql_contains_errors,
      "graphql_api_timeout" => graphql_api_timeout,
    }

    request.env["govuk.prometheus_labels"] = prometheus_labels.merge(hash)
  end
end

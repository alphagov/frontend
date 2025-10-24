module ContentItemLoaders
  class GraphqlLoader
    include DraftHelper

    GRAPHQL_TRAFFIC_RATES = {
      # These are decimal versions of a percentage, so can be between 0 and 1
      "news_article" => 0.5,
      "transaction" => 0,
      "travel_advice" => 0,
    }.freeze
    GRAPHQL_ALLOWED_SCHEMAS = GRAPHQL_TRAFFIC_RATES.keys

    def initialize(content_store_loader:, request:)
      @content_store_loader = content_store_loader
      @request = request
    end

    def can_load?(base_path:)
      return false unless request

      return false if draft_host?

      schema_from_content_store = content_store_loader.load(base_path:)["schema_name"]
      return false unless GRAPHQL_ALLOWED_SCHEMAS.include?(schema_from_content_store)

      if request.params["graphql"] == "true"
        return true
      elsif request.params["graphql"] == "false"
        return false
      end

      random_number = Random.rand(1.0)
      random_number < GRAPHQL_TRAFFIC_RATES.fetch(schema_from_content_store)
    end

    def load(base_path:)
      load_from_graphql(base_path)
    end

  private

    attr_reader :content_store_loader, :request

    def load_from_graphql(base_path)
      set_prometheus_labels
      GdsApi.publishing_api.graphql_live_content_item(base_path)
    rescue GdsApi::HTTPErrorResponse => e
      set_prometheus_labels(graphql_status_code: e.code)
      raise ContentItemLoaders::UnableToLoad
    rescue GdsApi::TimedOutException
      set_prometheus_labels(graphql_api_timeout: true)
      raise ContentItemLoaders::UnableToLoad
    end

    def set_prometheus_labels(graphql_status_code: 200, graphql_api_timeout: false)
      prometheus_labels = request.env.fetch("govuk.prometheus_labels", {})

      hash = {
        "graphql_status_code" => graphql_status_code,
        "graphql_api_timeout" => graphql_api_timeout,
      }

      request.env["govuk.prometheus_labels"] = prometheus_labels.merge(hash)
    end
  end
end

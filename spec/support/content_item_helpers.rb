require "gds_api/test_helpers/content_store"
require "support/publishing_api_graphql_helpers"

module ContentItemHelpers
  include PublishingApiGraphqlHelpers

  def fetch_content_item(document_type, example_name, data_source:)
    case data_source
    when :content_store
      GovukSchemas::Example.find(document_type, example_name: example_name)
    when :publishing_api_graphql
      fetch_graphql_content_item(example_name)
    end
  end

  def stub_request_for_content_item(base_path, api_response, data_source:)
    case data_source
    when :content_store
      stub_content_store_has_item(base_path, api_response)
    when :publishing_api_graphql
      stub_publishing_api_graphql_content_item(Graphql::EditionQuery.new(base_path).query, api_response)
    end
  end
end

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
end

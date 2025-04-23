require "gds_api/test_helpers/publishing_api"

module PublishingApiGraphqlHelpers
  include GdsApi::TestHelpers::PublishingApi

  def graphql_has_example_item(filename)
    graphql_response = fetch_graphql_fixture(filename)
    content_item = graphql_response.dig("data", "edition")

    stub_publishing_api_graphql_content_item(
      Graphql::EditionQuery.new(content_item.fetch("base_path")).query,
      graphql_response,
    )

    content_item
  end

private

  def fetch_graphql_fixture(filename)
    json = File.read(
      Rails.root.join("spec", "fixtures", "graphql", "#{filename}.json"),
    )
    JSON.parse(json)
  end
end

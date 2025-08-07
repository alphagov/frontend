require "gds_api/test_helpers/publishing_api"

module PublishingApiGraphqlHelpers
  include GdsApi::TestHelpers::PublishingApi

  def graphql_has_example_item(filename)
    graphql_response = fetch_graphql_fixture(filename)

    stub_publishing_api_graphql_has_item(
      graphql_response.fetch("base_path"),
      graphql_response,
    )

    graphql_response
  end

  def fetch_graphql_fixture(filename)
    json = File.read(
      Rails.root.join("spec", "fixtures", "graphql", "#{filename}.json"),
    )
    JSON.parse(json)
  end
end

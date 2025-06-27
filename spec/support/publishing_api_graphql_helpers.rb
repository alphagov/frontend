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

  def fetch_graphql_content_item(fixture_filename)
    fetch_graphql_fixture(fixture_filename).dig("data", "edition")
  end

  def graphql_has_schema_name_for_content_item(content_item)
    content_item.as_json.tap do
      graphql_has_schema_name_for_base_path(
        _1.fetch("schema_name"),
        _1.fetch("base_path"),
      )
    end
  end

private

  def fetch_graphql_fixture(filename)
    json = File.read(
      Rails.root.join("spec", "fixtures", "graphql", "#{filename}.json"),
    )
    JSON.parse(json)
  end

  def graphql_has_schema_name_for_base_path(schema_name, base_path)
    graphql_response = {
      "data" => {
        "edition" => {
          "schema_name" => schema_name,
        },
      },
    }

    stub_publishing_api_graphql_content_item(
      Graphql::SchemaNameQuery.new(base_path).query,
      graphql_response,
    )
  end
end

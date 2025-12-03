RSpec.describe "graphql_traffic_rates initializer" do
  let(:initializer_path) { Rails.root.join("config/initializers/graphql_traffic_rates.rb") }

  around do |example|
    ClimateControl.modify(
      "GRAPHQL_RATE_NEWS_ARTICLE": "0.25",
      "GRAPHQL_RATE_PLACE": "0.75",
    ) do
      example.run
    end
  end

  it "populates Rails.application.config.graphql_traffic_rates from ENV" do
    load initializer_path

    expect(Rails.application.config.graphql_traffic_rates).to eq(
      {
        "news_article" => 0.25,
        "place" => 0.75,
      },
    )
  end

  it "populates Rails.application.config.graphql_allowed_schemas from ENV" do
    load initializer_path

    expect(Rails.application.config.graphql_allowed_schemas).to eq(%w[news_article place])
  end
end

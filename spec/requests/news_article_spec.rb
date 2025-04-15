require "gds_api/test_helpers/publishing_api"

RSpec.describe "News Article" do
  include GdsApi::TestHelpers::PublishingApi

  describe "GET show" do
    context "when loaded from content store" do
      let(:content_item) { GovukSchemas::Example.find("news_article", example_name: "news_article") }
      let(:base_path) { content_item.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_item)

        get base_path
      end

      it "succeeds" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end

      it "sets cache-control headers" do
        expect(response).to honour_content_store_ttl
      end
    end

    context "when loaded from GraphQL" do
      let(:graphql_fixture) { fetch_graphql_fixture("news_article") }
      let(:base_path) { graphql_fixture.dig("data", "edition", "base_path") }

      before do
        stub_publishing_api_graphql_content_item(Graphql::EditionQuery.new(base_path).query, graphql_fixture)

        get base_path, params: { graphql: true }
      end

      it "succeeds" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end
  end

  def fetch_graphql_fixture(filename)
    json = File.read(
      Rails.root.join("spec", "fixtures", "graphql", "#{filename}.json"),
    )
    JSON.parse(json)
  end
end

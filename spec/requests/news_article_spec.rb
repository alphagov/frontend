require "gds_api/test_helpers/publishing_api"

RSpec.describe "News Article" do
  include Capybara::RSpecMatchers
  include GdsApi::TestHelpers::PublishingApi

  let(:content_item) { GovukSchemas::Example.find("news_article", example_name: "news_article") }
  let(:base_path) { content_item.fetch("base_path") }

  describe "GET show" do
    context "when loaded from content store" do
      before do
        stub_content_store_has_item(base_path, content_item)

        get base_path, params: { graphql: false }
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
      before do
        stub_content_store_has_item(base_path, content_item)
        stub_publishing_api_graphql_has_item(base_path, content_item)

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
end

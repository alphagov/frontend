require "gds_api/test_helpers/search"

RSpec.describe "Landing Page" do
  include GdsApi::TestHelpers::Search

  describe "GET show" do
    context "when a content item does exist" do
      let(:content_item) { GovukSchemas::Example.find("landing_page", example_name: "landing_page") }
      let(:base_path) { content_item.fetch("base_path") }

      before do
        stub_content_store_has_item(base_path, content_item)
        stub_content_store_has_item(basic_taxon["base_path"], basic_taxon)
        stub_any_search_to_return_no_results
      end

      it "succeeds" do
        get base_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the show template" do
        get base_path

        expect(response).to render_template(:show)
      end
    end
  end
end

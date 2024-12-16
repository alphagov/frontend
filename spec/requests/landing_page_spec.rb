require "gds_api/test_helpers/search"

RSpec.describe "Landing Page" do
  include GdsApi::TestHelpers::Search

  describe "GET show" do
    context "when a content item does exist" do
      let(:content_item) { GovukSchemas::Example.find("landing_page", example_name: "landing_page") }
      let(:base_path) { content_item.fetch("base_path") }

      before do
        stub_const("LandingPage::ADDITIONAL_CONTENT_PATH", "spec/fixtures")
        content_item["details"]["attachments"] = [
          {
            "accessible" => false,
            "attachment_type" => "document",
            "content_type" => "text/csv",
            "file_size" => 123,
            "filename" => "data_one.csv",
            "id" => 12_345,
            "preview_url" => "https://ignored-asset-domain/media/000000000000000000000001/data_one.csv/preview",
            "title" => "Data One",
            "url" => "https://ignored-asset-domain/media/000000000000000000000001/data_one.csv",
          },
        ]
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

    context "when a content item does not exist" do
      let(:base_path) { "/landing-page" }

      before do
        stub_const("LandingPage::ADDITIONAL_CONTENT_PATH", "spec/fixtures")
        stub_content_store_does_not_have_item(base_path)
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

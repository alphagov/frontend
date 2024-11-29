RSpec.describe "LandingPage" do
  include SearchHelpers

  context "show" do
    let(:content_item) do
      {
        "base_path" => "/landing-page",
        "title" => "Landing Page",
        "description" => "A landing page example",
        "locale" => "en",
        "document_type" => "landing_page",
        "schema_name" => "landing_page",
        "publishing_app" => "whitehall",
        "rendering_app" => "frontend",
        "update_type" => "major",
        "details" => {
          "attachments" => [
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
          ],
        },
        "routes" => [
          {
            "type" => "exact",
            "path" => "/landing-page",
          },
        ],
      }
    end

    let(:base_path) { content_item["base_path"] }

    before do
      stub_const("LandingPage::ADDITIONAL_CONTENT_PATH", "spec/fixtures")
      stub_content_store_has_item(base_path, content_item)
      stub_request(:get, %r{/media/000000000000000000000001/data_one.csv}).to_return(status: 200, body: File.read("spec/fixtures/landing_page_statistics_data/data_one.csv"), headers: {})
      stub_content_store_has_item(basic_taxon["base_path"], basic_taxon)
      stub_taxon_search_results
    end

    it "displays the page" do
      visit base_path

      expect(page.status_code).to eq(200)
    end

    it "renders a hero" do
      visit base_path

      assert_selector ".landing-page .govuk-block__hero"
      assert_selector ".govuk-block__hero picture"
      assert_selector ".govuk-block__hero .app-b-hero__textbox"
    end

    it "renders a card" do
      visit base_path

      assert_selector ".landing-page .app-b-card"
      assert_selector ".app-b-card .app-b-card__textbox"
      assert_selector ".app-b-card .app-b-card__figure"
      assert_selector ".app-b-card__figure .app-b-card__image"
    end

    it "renders a column layout" do
      visit base_path

      assert_selector ".landing-page .app-b-columns-layout"
    end

    it "renders a blocks container" do
      visit base_path

      assert_selector ".landing-page .blocks-container"
    end

    it "renders main navigation" do
      visit base_path

      assert_selector ".app-b-main-nav"
    end

    it "renders breadcrumbs" do
      visit base_path

      assert_selector ".govuk-breadcrumbs"
    end

    it "renders a document list" do
      visit base_path

      assert_selector ".gem-c-heading"
      assert_selector ".gem-c-document-list"
    end
  end
end

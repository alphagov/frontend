RSpec.describe "LandingPage" do
  include SearchHelpers

  describe "show" do
    let(:content_item) do
      {
        "base_path" => "/landing-page",
        "title" => "Landing Page",
        "description" => "A landing page example",
        "locale" => "en",
        "document_type" => "landing_page",
        "schema_name" => "landing_page",
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

    it "has a meta description tag" do
      visit base_path

      expect(page).to have_css('meta[name="description"][content="A landing page example"]', visible: :hidden)
    end

    it "renders a hero" do
      visit base_path

      expect(page).to have_selector(".landing-page .govuk-block__hero")
      expect(page).to have_selector(".govuk-block__hero picture")
      expect(page).to have_selector(".govuk-block__hero .app-b-hero__textbox")
    end

    it "renders a card" do
      visit base_path

      expect(page).to have_selector(".landing-page .app-b-card")
      expect(page).to have_selector(".app-b-card .app-b-card__textbox")
      expect(page).to have_selector(".app-b-card .app-b-card__figure")
      expect(page).to have_selector(".app-b-card__figure .app-b-card__image")
    end

    it "renders a column layout" do
      visit base_path

      expect(page).to have_selector(".landing-page .app-b-columns-layout")
    end

    it "renders a blocks container" do
      visit base_path

      expect(page).to have_selector(".landing-page .blocks-container")
    end

    it "renders main navigation" do
      visit base_path

      expect(page).to have_selector(".app-b-main-nav")
    end

    it "renders breadcrumbs" do
      visit base_path

      expect(page).to have_selector(".govuk-breadcrumbs")
    end

    it "renders a document list" do
      visit base_path

      expect(page).to have_selector(".gem-c-heading")
      expect(page).to have_selector(".gem-c-document-list")
    end

    context "when the block has errors" do
      it "doesn't render the erroring block, or replace it with an block-error block" do
        visit base_path

        expect(page).not_to have_content("replace me with a block-error block")
        expect(page).not_to have_content("Couldn't identify a model class for type: does_not_exist")
      end

      context "when viewed on the draft server" do
        before do
          stub_content_store_has_item(base_path, content_item, draft: true)
          stub_content_store_has_item(basic_taxon["base_path"], basic_taxon, draft: true)
          stub_taxon_search_results(draft: true)
        end

        it "renders the erroring block as a block-error block" do
          ClimateControl.modify(PLEK_HOSTNAME_PREFIX: "draft-") do
            visit base_path

            expect(page).to have_content("Couldn't identify a model class for type: does_not_exist")
          end
        end
      end
    end
  end
end

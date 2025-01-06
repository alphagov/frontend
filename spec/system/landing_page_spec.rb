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
      expect(page).to have_selector(".govuk-block__hero .hero__textbox")
    end

    it "renders a card" do
      visit base_path

      expect(page).to have_selector(".landing-page .card")
      expect(page).to have_selector(".card .card__textbox")
      expect(page).to have_selector(".card .card__figure")
      expect(page).to have_selector(".card__figure .card__image")
    end

    it "renders a column layout" do
      visit base_path

      expect(page).to have_selector(".landing-page .columns-layout")
    end

    it "renders a blocks container" do
      visit base_path

      expect(page).to have_selector(".landing-page .blocks-container")
    end

    it "renders main navigation" do
      visit base_path

      expect(page).to have_selector(".main-nav")
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

    it "does not render the number 10 header" do
      visit base_path

      expect(page).not_to have_selector(".landing-page-header__org")
      expect(page).not_to have_selector(".landing-page-header__org .brand--prime-ministers-office-10-downing-street")
    end

    context "with the prime-ministers-office-10-downing-street theme" do
      before do
        stub_content_store_has_item(base_path, content_item.deep_merge({ "details" => { "theme" => "prime-ministers-office-10-downing-street" } }))
      end

      it "renders the number 10 header" do
        visit base_path

        expect(page).to have_selector(".landing-page-header__org")
        expect(page).to have_selector(".landing-page-header__org .brand--prime-ministers-office-10-downing-street")
      end
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

    context "organisation logo" do
      before do
        stub_content_store_has_item(base_path, content_item.deep_merge({ "details" => { "theme" => "prime-ministers-office-10-downing-street" } }))
      end
      it "has ga4 tracking on the organisation logo" do
        visit base_path
        expect(page).to have_selector(".gem-c-organisation-logo[data-module=ga4-link-tracker]")
        expect(page).to have_selector(".gem-c-organisation-logo[data-ga4-track-links-only]")
        expect(page).to have_selector(".gem-c-organisation-logo[data-ga4-link='{\"event_name\":\"navigation\",\"section\":\"Header\",\"type\":\"organisation logo\"}']")
      end
    end

    context "columns layout" do
      it "has ga4 tracking on the columns layout" do
        visit base_path
        expect(page).to have_selector(".columns-layout[data-module=ga4-link-tracker]")
        expect(page).to have_selector(".columns-layout[data-ga4-track-links-only]")
        expect(page).to have_selector(".columns-layout[data-ga4-set-indexes]")
        expect(page).to have_selector(".columns-layout[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"box\"}']")
      end
    end

    context "main navigation" do
      it "has ga4 tracking on the main navigation" do
        visit base_path
        expect(page).to have_selector(".main-nav__nav-container nav[data-module=ga4-link-tracker]")
        expect(page).to have_selector(".main-nav__list-item a[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"secondary header\",\"index_link\":1,\"index_total\":2,\"index_section\":1,\"index_section_count\":2,\"section\":\"Heading\"}']")
        expect(page).to have_selector(".main-nav__list-item a[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"secondary header\",\"index_link\":2,\"index_total\":2,\"index_section\":2,\"index_section_count\":2,\"section\":\"Heading 2\"}']")
      end
    end
  end
end

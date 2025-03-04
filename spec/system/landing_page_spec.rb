RSpec.describe "LandingPage" do
  include SearchHelpers

  let(:landing_page_example) { GovukSchemas::Example.find(:landing_page, example_name: :landing_page) }
  let(:base_path) { landing_page_example["base_path"] }

  describe "GET <landing-page>" do
    before do
      stub_content_store_has_item(base_path, landing_page_example)
      stub_content_store_has_item(basic_taxon["base_path"], basic_taxon)
      stub_taxon_search_results
    end

    it "displays the page" do
      visit base_path

      expect(page.status_code).to eq(200)
    end

    it "has a meta description tag" do
      visit base_path

      expect(page).to have_css('meta[name="description"][content="some description"]', visible: :hidden)
    end

    it "renders a hero" do
      visit base_path

      expect(page).to have_selector(".govuk-block__hero")
      expect(page).to have_selector(".govuk-block__hero picture")
      expect(page).to have_selector(".govuk-block__hero .hero__textbox")
    end

    it "renders a card" do
      visit base_path

      expect(page).to have_selector(".card")
      expect(page).to have_selector(".card .card__textbox")
      expect(page).to have_selector(".card .card__figure")
      expect(page).to have_selector(".card__figure .card__image")
    end

    it "renders a column layout" do
      visit base_path

      expect(page).to have_selector(".columns-layout")
    end

    it "renders a blocks container" do
      visit base_path

      expect(page).to have_selector(".blocks-container")
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
        stub_content_store_has_item(base_path, landing_page_example.deep_merge({ "details" => { "theme" => "prime-ministers-office-10-downing-street" } }))
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

      context "and is being viewed on the draft server" do
        before do
          stub_content_store_has_item(base_path, landing_page_example, draft: true)
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

    describe "organisation logo" do
      before do
        stub_content_store_has_item(base_path, landing_page_example.deep_merge({ "details" => { "theme" => "prime-ministers-office-10-downing-street" } }))
      end

      it "has ga4 tracking on the organisation logo" do
        visit base_path

        expect(page).to have_selector(".gem-c-organisation-logo[data-module=ga4-link-tracker]")
        expect(page).to have_selector(".gem-c-organisation-logo[data-ga4-track-links-only]")
        expect(page).to have_selector(".gem-c-organisation-logo[data-ga4-link='{\"event_name\":\"navigation\",\"section\":\"Header\",\"type\":\"organisation logo\"}']")
      end
    end

    describe "columns layout" do
      it "has ga4 tracking on the columns layout" do
        visit base_path

        expect(page).to have_selector(".columns-layout[data-module=ga4-link-tracker]")
        expect(page).to have_selector(".columns-layout[data-ga4-track-links-only]")
        expect(page).to have_selector(".columns-layout[data-ga4-set-indexes]")
        expect(page).to have_selector(".columns-layout[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"box\"}']")
      end
    end

    describe "main navigation" do
      it "has ga4 tracking on the main navigation" do
        visit base_path

        expect(page).to have_selector(".main-nav__nav-container nav[data-module=ga4-link-tracker]")
        expect(page).to have_selector(".main-nav__list-item a[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"secondary header\",\"index_link\":1,\"index_total\":2,\"index_section\":1,\"index_section_count\":2,\"section\":\"Heading\"}']")
        expect(page).to have_selector(".main-nav__list-item a[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"secondary header\",\"index_link\":2,\"index_total\":2,\"index_section\":2,\"index_section_count\":2,\"section\":\"Heading 2\"}']")
      end
    end
  end
end

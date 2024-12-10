RSpec.describe "Homepage" do
  before { stub_content_store_has_item("/", schema: "special_route", links: {}) }

  it "renders the homepage" do
    visit "/"

    expect(page.status_code).to eq(200)
    expect(page.title).to eq("Welcome to GOV.UK")
    expect(page).to have_css(".homepage-header__title")
    expect(page).not_to have_css(".homepage-inverse-header__title")
  end

  describe "search autocomplete" do
    context "when autocomplete is enabled" do
      it "renders the search with autocomplete component with the correct source URL" do
        ClimateControl.modify GOVUK_DISABLE_SEARCH_AUTOCOMPLETE: nil do
          visit "/"

          expect(page).to have_css(".gem-c-search-with-autocomplete")
          expect(page).to have_css("[data-source-url='http://www.dev.gov.uk/api/search/autocomplete.json']")
        end
      end
    end

    context "when autocomplete is disabled" do
      it "does not render the search with autocomplete component" do
        ClimateControl.modify GOVUK_DISABLE_SEARCH_AUTOCOMPLETE: "1" do
          visit "/"

          expect(page).to_not have_css(".gem-c-search-with-autocomplete")
          expect(page).to have_css(".gem-c-search")
        end
      end
    end
  end

  context "when visiting a Welsh content item first" do
    before do
      @payload = {
        base_path: "/cymraeg",
        content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
        document_type: "transaction",
        locale: "cy",
        publishing_app: "publisher",
        rendering_app: "frontend",
        schema_name: "transaction",
        title: "Cymraeg",
        description: "Cynnwys Cymraeg",
        details: {
          transaction_start_link: "http://cymraeg.example.com",
          start_button_text: "Start now",
        },
      }
      stub_content_store_has_item("/cymraeg", @payload)
    end

    it "uses the English locale after visiting the Welsh content" do
      visit @payload[:base_path]
      visit "/"

      expect(page).to have_content(I18n.t("homepage.index.government_activity_description", locale: :en))
    end
  end
end

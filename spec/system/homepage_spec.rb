RSpec.describe "Homepage" do
  include GovukAbTesting::RspecHelpers
  include ContentStoreHelpers

  before do
    links = {
      "popular_links" => [
        {
          "details" => {
            "link_items" => [
              {
                "title" => "Some popular links title",
                "url" => "/some/path",
              },
            ],
          },
        },
      ],
    }

    stub_homepage_content_item(links:)
  end

  it "renders the homepage" do
    visit "/"

    expect(page.status_code).to eq(200)
    expect(page.title).to eq("Welcome to GOV.UK")
    expect(page).to have_css(".homepage-header__title")
    expect(page).not_to have_css(".homepage-inverse-header__title")
  end

  it "shows popular links" do
    visit "/"

    expect(page).to have_content("Some popular links title")
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

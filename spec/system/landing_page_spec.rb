RSpec.describe "LandingPage" do
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
        "details" => {},
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
  end
end

RSpec.describe "FlexiblePage" do
  let(:base_path) { "/flexible-page" }

  before do
    ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = "true"
    stub_const("ContentItemLoader::LOCAL_ITEMS_PATH", "spec/fixtures/local-content-items")
  end

  after do
    ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = nil
  end

  describe "GET <flexible-page>" do
    it "has a meta description tag" do
      visit base_path

      expect(page).to have_css('meta[name="description"][content="This is the history of 10 Downing Street"]', visible: :hidden)
    end

    it "renders a page_title flexible section" do
      visit base_path

      expect(page).to have_selector("h1", text: "10 Downing Street")
      expect(page).to have_text("History")
    end

    it "renders a rich_content flexible section" do
      visit base_path

      expect(page).to have_selector("h2.gem-c-contents-list__title", text: "Contents")
      expect(page).to have_selector("ol.gem-c-contents-list__list li", text: "Introduction")

      expect(page).to have_selector(".govuk-govspeak h2", text: "Introduction – by Sir Anthony Seldon")
      expect(page).to have_text("vies with the White House as being the most important political building anywhere in the world")
    end
  end
end

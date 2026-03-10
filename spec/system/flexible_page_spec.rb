RSpec.describe "FlexiblePage" do
  let(:base_path) { "/flexible-page" }

  before do
    ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = "true"
    stub_const("ContentItemLoaders::LocalFileLoader::LOCAL_ITEMS_PATH", "spec/fixtures/local-content-items")
  end

  after do
    ENV["ALLOW_LOCAL_CONTENT_ITEM_OVERRIDE"] = nil
  end

  describe "GET <flexible-page>" do
    it "has a meta description tag" do
      visit base_path

      expect(page).to have_css('meta[name="description"][content="This is the history of 10 Downing Street"]', visible: :hidden)
    end

    describe "renders a breadcrumbs flexible section" do
      it "contains the basic expected element within the before content block" do
        visit base_path

        expect(page).to have_selector("[data-flexible-section='breadcrumbs']")
        within(".govuk-main-wrapper") do
          expect(page).not_to have_selector("[data-flexible-section='breadcrumbs']")
        end
      end
    end

    it "renders a page_title flexible section" do
      visit base_path

      expect(page).to have_selector("h1", text: "10 Downing Street")
      expect(page).to have_text("History")
      expect(page).to have_text("This is the lead paragraph")
    end

    it "renders a rich_content flexible section" do
      visit base_path

      expect(page).to have_selector("h2.gem-c-contents-list__title", text: "Contents")
      expect(page).to have_selector("ol.gem-c-contents-list__list li", text: "Introduction")

      expect(page).to have_selector(".govuk-govspeak h2", text: "Introduction – by Sir Anthony Seldon")
      expect(page).to have_text("vies with the White House as being the most important political building anywhere in the world")
    end

    describe "renders a feed flexible section" do
      it "contains the basic expected elements" do
        visit base_path

        expect(page).to have_selector("[data-flexible-section='feed_document_list']")
      end
    end

    describe "renders a featured flexible section" do
      it "contains the basic expected elements" do
        visit base_path

        expect(page).to have_selector("[data-flexible-section='featured']")
      end
    end

    describe "renders a who's involved flexible section" do
      it "contains the basic expected elements" do
        visit base_path

        expect(page).to have_selector("[data-flexible-section='involved']")
      end
    end

    describe "renders a link flexible section" do
      it "contains the basic expected elements" do
        visit base_path

        expect(page).to have_selector("[data-flexible-section='link']")
      end
    end

    describe "renders an impact header" do
      it "contains the basic expected elements" do
        visit base_path

        expect(page).to have_selector("[data-flexible-section='impact-header']")
      end
    end
  end
end

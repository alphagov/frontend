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

        expect(page).to have_selector(".gem-c-heading", text: "Featured")
        expect(page).to have_selector(".govuk-grid-column-one-third .gem-c-image-card .gem-c-image-card__description", text: "This is what five (or more) featured items look like. We also need to test what happens when they're different heights.")
      end

      it "renders a single featured item as large" do
        visit base_path

        featured_items = page.all("[data-flexible-section='featured']")
        within featured_items[0] do
          expect(page).to have_selector(".govuk-grid-column-full .gem-c-image-card.gem-c-image-card--large", count: 1)
        end
      end

      it "renders two featured items side by side" do
        visit base_path

        featured_items = page.all("[data-flexible-section='featured']")
        within featured_items[1] do
          expect(page).to have_selector(".govuk-grid-row", count: 1)
          expect(page).to have_selector(".govuk-grid-column-one-half .gem-c-image-card", count: 2)
          expect(page).not_to have_selector(".gem-c-image-card--large")
        end
      end

      it "renders three featured items in one row" do
        visit base_path

        featured_items = page.all("[data-flexible-section='featured']")
        within featured_items[2] do
          expect(page).to have_selector(".govuk-grid-row", count: 1)
          expect(page).to have_selector(".govuk-grid-column-one-third .gem-c-image-card", count: 3)
          expect(page).not_to have_selector(".gem-c-image-card--large")
        end
      end

      it "renders four featured items in two rows" do
        visit base_path

        featured_items = page.all("[data-flexible-section='featured']")
        within featured_items[3] do
          expect(page).to have_selector(".govuk-grid-row", count: 2)
          expect(page).to have_selector(".govuk-grid-column-one-half .gem-c-image-card", count: 4)
          expect(page).not_to have_selector(".gem-c-image-card--large")
        end
      end

      it "renders five featured items in two rows" do
        visit base_path

        featured_items = page.all("[data-flexible-section='featured']")
        within featured_items[4] do
          expect(page).to have_selector(".govuk-grid-row", count: 2)
          expect(page).to have_selector(".govuk-grid-column-one-third .gem-c-image-card", count: 5)
          expect(page).not_to have_selector(".gem-c-image-card--large")
        end
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
  end
end

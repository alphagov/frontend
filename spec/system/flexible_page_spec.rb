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
      it "with a document list" do
        visit base_path

        within "div[data-flexible-section=feed_document_list]" do
          expect(page).to have_selector("h2", text: "Latest")

          expect(page).to have_selector("ul.gem-c-document-list")

          within "li.gem-c-document-list__item:first-of-type" do
            expect(page).to have_link("Alternative provision", href: "/government/publications/alternative-provision")
            expect(page).to have_selector(".gem-c-document-list__item-metadata time", text: "31 October 2025")
            expect(page).to have_selector(".gem-c-document-list__item-metadata .gem-c-document-list__attribute", text: "Statutory guidance")
          end

          within "li.gem-c-document-list__item:nth-of-type(2)" do
            expect(page).to have_link("Behaviour and discipline in schools: guide for governing bodies", href: "/government/publications/behaviour-and-discipline-in-schools-guidance-for-governing-bodies")
            expect(page).to have_selector(".gem-c-document-list__item-metadata time", text: "31 October 2025")
            expect(page).to have_selector(".gem-c-document-list__item-metadata .gem-c-document-list__attribute", text: "Statutory guidance")
          end

          within "li.gem-c-document-list__item:nth-of-type(3)" do
            expect(page).to have_link("Children missing education", href: "/government/publications/children-missing-education")
            expect(page).to have_selector(".gem-c-document-list__item-metadata time", text: "31 October 2025")
            expect(page).to have_selector(".gem-c-document-list__item-metadata .gem-c-document-list__attribute", text: "Statutory guidance")
          end
        end
      end

      it "with a see all link" do
        visit base_path

        within "[data-flexible-section=feed_document_list] ul + p" do
          expect(page).to have_link("See all", href: "/search/all")
        end

        ga4_link_data = JSON.parse(page.first("[data-flexible-section=feed_document_list] ul + p")["data-ga4-link"])
        expected_tracking = { "event_name" => "navigation", "type" => "see all", "section" => "Latest" }
        expect(ga4_link_data).to eq(expected_tracking)
      end

      it "with subscription links" do
        visit base_path

        within "[data-flexible-section=feed_document_list] .gem-c-subscription-links" do
          expect(page).to have_link("Get emails", href: "/something")
        end

        ga4_link_data = JSON.parse(page.first("[data-flexible-section=feed_document_list] .gem-c-subscription-links")["data-ga4-link"])
        expected_tracking = { "event_name" => "navigation", "type" => "subscribe", "index_link" => 1, "index_total" => 1, "section" => "Latest" }
        expect(ga4_link_data).to eq(expected_tracking)
      end

      it "with share links" do
        visit base_path

        within "[data-flexible-section=feed_share_links]" do
          expect(page).to have_selector("h2", text: "Follow us")
          expect(page).to have_selector("p.govuk-body-s", text: "The following links open in a new tab")
          expect(page).to have_selector("ul.gem-c-share-links__list")

          within "ul.gem-c-share-links__list li.gem-c-share-links__list-item" do
            expect(page).to have_link("Facebook", href: "/facebook-share-link")
            expect(page).to have_selector(".gem-c-share-links__link-icon .gem-c-share-links__svg")
          end
        end
      end
    end

    describe "renders a featured flexible section" do
      it "contains the basic expected elements" do
        visit base_path

        expect(page).to have_selector(".gem-c-heading", text: "Featured")
        expect(page).to have_selector(".govuk-grid-column-one-third .gem-c-image-card .gem-c-image-card__description", text: "This is what five (or more) featured items look like. We also need to test what happens when they're different heights.")
      end
    end
  end
end

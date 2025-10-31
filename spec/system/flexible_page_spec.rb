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

    it "renders a feed flexible section" do
      visit base_path

      # Document List
      expect(page).to have_selector("[data-flexible-section=feed_document_list] h2", text: "Latest")

      expect(page).to have_selector("ul.gem-c-document-list")

      within "li.gem-c-document-list__item:first-of-type" do
        expect(page).to have_link("Alternative provision", href: "/government/publications/alternative-provision")
      end

      expect(page).to have_selector("li.gem-c-document-list__item:first-of-type a", text: "Alternative provision")
      expect(page).to have_selector("li.gem-c-document-list__item:first-of-type .gem-c-document-list__item-metadata time", text: "31 October 2025")
      expect(page).to have_selector("li.gem-c-document-list__item:first-of-type .gem-c-document-list__item-metadata .gem-c-document-list__attribute", text: "Statutory guidance")

      within "li.gem-c-document-list__item:nth-of-type(2)" do
        expect(page).to have_link("Behaviour and discipline in schools: guide for governing bodies", href: "/government/publications/behaviour-and-discipline-in-schools-guidance-for-governing-bodies")
      end

      expect(page).to have_selector("li.gem-c-document-list__item:nth-of-type(2) .gem-c-document-list__item-metadata time", text: "31 October 2025")
      expect(page).to have_selector("li.gem-c-document-list__item:nth-of-type(2) .gem-c-document-list__item-metadata .gem-c-document-list__attribute", text: "Statutory guidance")

      within "li.gem-c-document-list__item:nth-of-type(3)" do
        expect(page).to have_link("Children missing education", href: "/government/publications/children-missing-education")
      end

      expect(page).to have_selector("li.gem-c-document-list__item:nth-of-type(3) .gem-c-document-list__item-metadata time", text: "31 October 2025")
      expect(page).to have_selector("li.gem-c-document-list__item:nth-of-type(3) .gem-c-document-list__item-metadata .gem-c-document-list__attribute", text: "Statutory guidance")

      # See all link
      within "p.govuk-body[data-flexible-section=feed_see_all]" do
        expect(page).to have_link("See all", href: "/search/all")
      end

      ga4_link_data = JSON.parse(page.first("p.govuk-body[data-flexible-section=feed_see_all]")["data-ga4-link"])
      expected_tracking = { "event_name" => "navigation", "type" => "see all", "section" => "Latest" }
      expect(ga4_link_data).to eq(expected_tracking)

      # Subscription link
      within "ul.gem-c-subscription-links__list" do
        expect(page).to have_link("Get emails", href: "/something")
      end

      ga4_link_data = JSON.parse(page.first("section[data-flexible-section=feed_subscription_links]")["data-ga4-link"])
      expected_tracking = { "event_name" => "navigation", "type" => "subscribe", "index_link" => 1, "index_total" => 1, "section" => "Latest" }
      expect(ga4_link_data).to eq(expected_tracking)

      # Share links
      expect(page).to have_selector("[data-flexible-section=feed_share_links] h2", text: "Follow us")
      expect(page).to have_selector(".gem-c-share-links p.govuk-body-s", text: "The following links open in a new tab")
      expect(page).to have_selector("ul.gem-c-share-links__list")

      within "ul.gem-c-share-links__list li.gem-c-share-links__list-item" do
        expect(page).to have_link("Facebook", href: "/facebook-share-link")
        expect(page).to have_selector(".gem-c-share-links__link-icon .gem-c-share-links__svg")
      end
    end
  end
end

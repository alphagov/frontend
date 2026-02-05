RSpec.describe "Feed flexible section" do
  let(:flexible_section) { FlexiblePage::FlexibleSection::Feed.new(section_hash, nil) }
  let(:section_hash) do
    {
      "feed_heading_text" => "Latest",
      "items" => [
        {
          "link" => {
            "text" => "Alternative provision",
            "path" => "/government/publications/alternative-provision",
          },
          "metadata" => {
            "public_updated_at" => "31 October 2025",
            "document_type" => "Statutory guidance",
          },
        },
      ],
      "share_links" => [
        {
          "href" => "/facebook-share-link",
          "text" => "Facebook",
          "icon" => "facebook",
          "data_attributes" => {
            "module": "example",
          },
        },
      ],
      "share_links_heading_text" => "Follow us",
      "email_signup_link" => "/email/get",
      "see_all_items_link" => "/search/all",
    }
  end

  before do
    render(template: "flexible_page/flexible_sections/_feed", locals: { flexible_section: })
  end

  describe "document list" do
    it "shows a heading over the document list" do
      expect(rendered).to have_selector("h2", text: "Latest")
    end

    it "shows the document list with documents" do
      expect(rendered).to have_selector("ul.gem-c-document-list")

      expect(rendered).to have_link("Alternative provision", href: "/government/publications/alternative-provision")
      expect(rendered).to have_selector(".gem-c-document-list__item-metadata time", text: "31 October 2025")
      expect(rendered).to have_selector(".gem-c-document-list__item-metadata .gem-c-document-list__attribute", text: "Statutory guidance")
    end

    it "shows a see all link" do
      expect(rendered).to have_link("See all", href: "/search/all")
    end

    it "has ga4 tracking on the see all link" do
      ga4_link_data = JSON.parse(rendered.html.css("[data-flexible-section=feed_document_list] ul + p").first["data-ga4-link"])

      expect(ga4_link_data).to eq({ "event_name" => "navigation", "type" => "see all", "section" => "Latest" })
    end

    it "has a subscription link" do
      expect(rendered).to have_link("Get emails", href: "/email/get")
    end

    it "has ga4 tracking on the subscription link" do
      ga4_link_data = JSON.parse(rendered.html.css("[data-flexible-section=feed_document_list] .gem-c-subscription-links").first["data-ga4-link"])

      expect(ga4_link_data).to eq({ "event_name" => "navigation", "type" => "subscribe", "index_link" => 1, "index_total" => 1, "section" => "Latest" })
    end
  end

  describe "share links" do
    it "shows the share links element" do
      expect(rendered).to have_selector("[data-flexible-section=feed_share_links]")
    end

    it "shows the share links title" do
      expect(rendered).to have_selector("h2", text: "Follow us")
    end

    it "shows the new tab warning" do
      expect(rendered).to have_selector("p.govuk-body-s", text: "The following links open in a new tab")
    end

    it "shows the share links list" do
      expect(rendered).to have_selector("ul.gem-c-share-links__list")
    end

    it "shows the share link items" do
      expect(rendered).to have_selector("[data-flexible-section=feed_document_list] .gem-c-subscription-links")
      expect(rendered).to have_link("Facebook", href: "/facebook-share-link")
      expect(rendered).to have_selector(".gem-c-share-links__link-icon .gem-c-share-links__svg")
    end

    context "when there are no share links" do
      let(:flexible_section) { FlexiblePage::FlexibleSection::Feed.new(section_hash.except("share_links"), nil) }

      it "does not show the share links element" do
        expect(rendered).not_to have_selector("[data-flexible-section=feed_share_links]")
      end
    end
  end
end

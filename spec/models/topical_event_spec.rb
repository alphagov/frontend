RSpec.describe TopicalEvent do
  include GdsApi::TestHelpers::Search

  subject(:topical_event) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }
  let(:search_results) do
    {
      results: [
        {
          link: "/news/my-item",
          title: "My Topical Event News Item",
          public_timestamp: "2025-12-01T00:00:01Z",
          display_type: "news",
          description: "What's up?",
        },
      ],
    }
  end

  before { stub_any_search.to_return(body: search_results.to_json) }

  describe "impact header initialisation" do
    let(:params) do
      {
        "breadcrumbs" => [{ "title" => "Home", "url" => "/" }],
        "description" => content_store_response["description"],
        "image_type" => "logo",
        "title" => content_store_response["title"],
        "image" => {
          "sources" => {
            "desktop" => content_store_response["details"]["image"]["high_resolution_url"],
            "desktop_2x" => nil,
            "tablet" => content_store_response["details"]["image"]["medium_resolution_url"],
            "tablet_2x" => nil,
            "mobile" => content_store_response["details"]["image"]["medium_resolution_url"],
            "mobile_2x" => nil,
          },
        },
        "type" => "impact_header",
        "variant" => "plain",
      }
    end

    it "creates an ImpactHeader with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::ImpactHeader).to receive(:new) do |settings, _|
        expect(settings).to eq(params)
      end

      topical_event
    end

    context "when there's no image" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"]["image"] = nil
        end
      end

      let(:params) do
        {
          "breadcrumbs" => [{ "title" => "Home", "url" => "/" }],
          "description" => content_store_response["description"],
          "image_type" => "logo",
          "title" => content_store_response["title"],
          "image" => nil,
          "type" => "impact_header",
          "variant" => "plain",
        }
      end

      it "creates an ImpactHeader with no image" do
        expect(FlexiblePage::FlexibleSection::ImpactHeader).to receive(:new) do |settings, _|
          expect(settings).to eq(params)
        end

        topical_event
      end
    end

    context "when there's an images array including a header image" do
      let(:params) do
        {
          "breadcrumbs" => [{ "title" => "Home", "url" => "/" }],
          "description" => content_store_response["description"],
          "image_type" => "header",
          "title" => content_store_response["title"],
          "image" => create_image_hash("header"),
          "type" => "impact_header",
          "variant" => "plain",
        }
      end

      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [
            create_image_hash("header"),
            create_image_hash("logo"),
          ]
        end
      end

      it "creates an ImpactHeader with image sources copied from details/images/header" do
        expect(FlexiblePage::FlexibleSection::ImpactHeader).to receive(:new) do |settings, _|
          expect(settings).to eq(params)
        end

        topical_event
      end
    end

    context "when there's an images array that includes a logo but no header image" do
      let(:params) do
        {
          "breadcrumbs" => [{ "title" => "Home", "url" => "/" }],
          "description" => content_store_response["description"],
          "image_type" => "logo",
          "title" => content_store_response["title"],
          "image" => create_image_hash("logo"),
          "type" => "impact_header",
          "variant" => "plain",
        }
      end

      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [
            create_image_hash("logo"),
          ]
        end
      end

      it "creates an ImpactHeader with image sources copied from details/images/logo" do
        expect(FlexiblePage::FlexibleSection::ImpactHeader).to receive(:new) do |settings, _|
          expect(settings).to eq(params)
        end

        topical_event
      end
    end

    context "when the topical event is tagged to /society-and-culture/notable-events" do
      let(:params) do
        {
          "breadcrumbs" => [{ "title" => "Home", "url" => "/" }],
          "description" => content_store_response["description"],
          "image_type" => "logo",
          "title" => content_store_response["title"],
          "image" => {
            "sources" => {
              "desktop" => content_store_response["details"]["image"]["high_resolution_url"],
              "desktop_2x" => nil,
              "tablet" => content_store_response["details"]["image"]["medium_resolution_url"],
              "tablet_2x" => nil,
              "mobile" => content_store_response["details"]["image"]["medium_resolution_url"],
              "mobile_2x" => nil,
            },
          },
          "type" => "impact_header",
          "variant" => "notable-death",
        }
      end

      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["links"]["taxons"] = [{
            "base_path" => "/society-and-culture/notable-death",
          }]
        end
      end

      it "creates an ImpactHeader with the variant set to notable-death" do
        expect(FlexiblePage::FlexibleSection::ImpactHeader).to receive(:new) do |settings, _|
          expect(settings).to eq(params)
        end

        topical_event
      end
    end
  end

  describe "body initialisation" do
    let(:params) do
      {
        "govspeak" => content_store_response["details"]["body"],
        "image" => nil,
        "type" => "body_with_image",
      }
    end

    it "creates a Body with Image without a logo (legacy logos always go in the impact header if present)" do
      expect(FlexiblePage::FlexibleSection::BodyWithImage).to receive(:new) do |settings, _|
        expect(settings).to eq(params)
      end

      topical_event
    end

    context "when a logo image (not legacy) is present but no header image" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [create_image_hash("logo")]
        end
      end

      it "creates a Body with Image without the logo (it has put it in the impact header)" do
        expect(FlexiblePage::FlexibleSection::BodyWithImage).to receive(:new) do |settings, _|
          expect(settings).to eq(params)
        end

        topical_event
      end
    end

    context "when both a logo image (not legacy) and a header image are present" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [create_image_hash("logo"), create_image_hash("header")]
        end
      end

      let(:params) do
        {
          "govspeak" => content_store_response["details"]["body"],
          "image" => create_image_hash("logo"),
          "type" => "body_with_image",
        }
      end

      it "creates a Body with Image with the logo" do
        expect(FlexiblePage::FlexibleSection::BodyWithImage).to receive(:new) do |settings, _|
          expect(settings).to eq(params)
        end

        topical_event
      end
    end

    context "when a body isn't present" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"]["body"] = nil
        end
      end

      it "doesn't create a Body with Image" do
        expect(FlexiblePage::FlexibleSection::BodyWithImage).not_to receive(:new)

        topical_event
      end
    end
  end

  describe "about link initialisation" do
    let(:params) do
      {
        "link_text" => content_store_response["details"]["about_page_link_text"],
        "link" => "#{content_store_response['base_path']}/about",
        "type" => "link",
      }
    end

    it "creates a Link with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Link).to receive(:new) do |settings, _|
        expect(settings).to eq(params)
      end

      topical_event
    end

    context "when about_page_link_text isn't present" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"]["about_page_link_text"] = nil
        end
      end

      it "doesn't create a Link" do
        expect(FlexiblePage::FlexibleSection::Link).not_to receive(:new)

        topical_event
      end
    end
  end

  describe "featured documents initialisation" do
    let(:params) do
      {
        "ordered_featured_documents" => content_store_response["details"]["ordered_featured_documents"],
        "type" => "featured",
        "ga4_image_card_json" => {
          "event_name" => "navigation",
          "type" => "image card",
          "section" => "Featured",
        },
      }
    end

    it "creates a Featured with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Featured).to receive(:new) do |settings, _|
        expect(settings).to eq(params)
      end

      topical_event
    end

    context "when there are no ordered_featured_documents" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"]["ordered_featured_documents"] = []
        end
      end

      it "doesn't create a Featured" do
        expect(FlexiblePage::FlexibleSection::Featured).not_to receive(:new)

        topical_event
      end
    end
  end

  describe "feed and social initialisation" do
    let(:params) do
      {
        "feed_heading_text" => "Latest updates",
        "items" => [{
          "link" => {
            "path" => "/news/my-item",
            "text" => "My Topical Event News Item",
          },
          "metadata" => {
            "document_type" => "News",
            "public_updated_at" => "2025-12-01T00:00:01Z",
            "display_type" => "news",
            "description" => "What's up?",
          },
        }],
        "email_signup_link" => "/email-signup?link=#{content_store_response['base_path']}",
        "email_signup_link_text" => "Get emails about this page",
        "see_all_items_link" => "/search/all?order=updated-newest&topical_events%5B%5D=western-balkans-summit-london-2018",
        "see_all_items_link_text" => "See more updates",
        "share_links" => [{ "href" => "https://twitter.com/foreignoffice", "icon" => "twitter", "text" => "Twitter" }],
        "share_links_heading_text" => "Follow us",
        "type" => "feed",
      }
    end

    it "creates a Feed with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Feed).to receive(:new) do |settings, _|
        expect(settings).to eq(params)
      end

      topical_event
    end
  end

  describe "who's involved initialisation" do
    let(:params) do
      {
        "organisations" => content_store_response["links"]["organisations"],
        "type" => "involved",
      }
    end

    it "creates an Involved with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Involved).to receive(:new) do |settings, _|
        expect(settings).to eq(params)
      end

      topical_event
    end

    context "when there are no organisations" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["links"]["organisations"] = nil
        end
      end

      it "doesn't create an Involved" do
        expect(FlexiblePage::FlexibleSection::Involved).not_to receive(:new)

        topical_event
      end
    end
  end
end

def create_image_hash(type)
  {
    "content_type" => "image/jpeg",
    "sources" => {
      "desktop" => "https://www.test.gov.uk/desktop_#{type}.jpg",
      "desktop_2x" => "https://www.test.gov.uk/desktop_#{type}_2x.jpg",
      "mobile" => "https://www.test.gov.uk/mobile_#{type}.jpg",
      "mobile_2x" => "https://www.test.gov.uk/mobile_#{type}_2x.jpg",
      "tablet" => "https://www.test.gov.uk/tablet_#{type}.jpg",
      "tablet_2x" => "https://www.test.gov.uk/tablet_#{type}_2x.jpg",
    },
    "type" => type,
  }
end

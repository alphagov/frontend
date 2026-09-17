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

  describe "feed initialisation" do
    it "creates a DocumentList with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::DocumentList).to receive(:new).with(
        email_signup_link: "/email-signup?link=#{content_store_response['base_path']}",
        email_signup_link_text: "Get email updates",
        heading_text: "Latest updates",
        items: [{
          link: {
            path: "/news/my-item",
            text: "My Topical Event News Item",
          },
          metadata: {
            document_type: "News",
            public_updated_at: Time.zone.parse("2025-12-01 00:00:01.000000000 +0000"),
            display_type: "news",
            description: "What's up?",
          },
        }],
        see_all_items_link: "/search/all?order=updated-newest&topical_events%5B%5D=western-balkans-summit-london-2018",
        see_all_items_link_text: "See more updates",
      )

      topical_event
    end
  end

  describe "social initialisation" do
    it "creates a Share with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Share).to receive(:new).with(
        links: [{
          href: "https://twitter.com/foreignoffice",
          icon: "twitter",
          text: "Twitter",
        }],
        heading_text: "Follow us",
      )

      topical_event
    end

    context "when there are no social_media_links" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"]["social_media_links"] = nil
        end
      end

      it "does not create a Share" do
        expect(FlexiblePage::FlexibleSection::Share).not_to receive(:new)

        topical_event
      end
    end
  end

  describe "who's involved initialisation" do
    it "creates an Involved with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Involved).to receive(:new) do |settings, _|
        expect(settings[:organisations].first).to be_a(Organisation)
        expect(settings[:organisations].first.title).to eq(content_store_response["links"]["organisations"][0]["title"])
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
    content_type: "image/jpeg",
    sources: {
      desktop: "https://www.test.gov.uk/desktop_#{type}.jpg",
      desktop_2x: "https://www.test.gov.uk/desktop_#{type}_2x.jpg",
      mobile: "https://www.test.gov.uk/mobile_#{type}.jpg",
      mobile_2x: "https://www.test.gov.uk/mobile_#{type}_2x.jpg",
      tablet: "https://www.test.gov.uk/tablet_#{type}.jpg",
      tablet_2x: "https://www.test.gov.uk/tablet_#{type}_2x.jpg",
    },
    type:,
  }
end

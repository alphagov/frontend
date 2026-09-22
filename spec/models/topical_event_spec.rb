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

  describe "about link initialisation" do
    it "creates a Link with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Link).to receive(:new).with(
        link: "#{content_store_response['base_path']}/about",
        link_text: content_store_response["details"]["about_page_link_text"],
      )

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
    it "creates a Featured with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::Featured).to receive(:new) do |settings, _|
        expect(settings[:items].count).to eq(5)
        expect(settings[:items].first).to eq({
          description: "The fifth Western Balkans Summit concluded on 10 July with the signing of joint declarations on Good Neighbourly Relations, War Crimes and Missing Persons.",
          heading_text: "UK hosts Western Balkans Summit",
          href: "/government/news/uk-hosts-western-balkans-summit",
          image_alt: "Family Photo",
          image_src: "https://assets.publishing.service.gov.uk/media/5b45a61be5274a3755402bfa/s465_IMG_11Jul2018at072855.jpg",
        })
        expect(settings[:ga4_image_card_json]).to eq({
          event_name: "navigation",
          type: "image card",
          section: "Featured",
        })
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

  describe "#header_image" do
    let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name:) }
    let(:example_name) { "topical-event" }

    it "returns the first image of type header" do
      expect(topical_event.header_image[:type]).to eq("header")
    end

    context "when rendering a legacy topical event" do
      let(:example_name) { "western-balkans-summit-london-2018" }

      it "returns nil" do
        expect(topical_event.header_image).to be_nil
      end
    end
  end

  describe "#logo_image" do
    let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name:) }
    let(:example_name) { "topical-event" }

    it "returns the first image of type logo" do
      expect(topical_event.logo_image[:type]).to eq("logo")
    end

    context "when rendering a legacy topical event" do
      let(:example_name) { "western-balkans-summit-london-2018" }

      it "returns nil" do
        expect(topical_event.logo_image).to be_nil
      end
    end
  end

  describe "#legacy_logo" do
    let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name:) }
    let(:example_name) { "topical-event" }

    it "returns nil" do
      expect(topical_event.legacy_logo).to be_nil
    end

    context "when rendering a legacy topical event" do
      let(:example_name) { "western-balkans-summit-london-2018" }

      it "returns the legacy logo suitable for use as a header image" do
        expect(topical_event.legacy_logo.key?(:type)).to be false
        expect(topical_event.legacy_logo[:sources]).not_to be_nil
      end
    end
  end
end

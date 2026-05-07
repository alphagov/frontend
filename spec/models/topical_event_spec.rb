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
        description: content_store_response["description"],
        image: {
          sources: {
            desktop: content_store_response["details"]["image"]["high_resolution_url"],
            desktop_2x: nil,
            tablet: content_store_response["details"]["image"]["medium_resolution_url"],
            tablet_2x: nil,
            mobile: content_store_response["details"]["image"]["medium_resolution_url"],
            mobile_2x: nil,
          },
        },
        image_type: :logo,
        title: content_store_response["title"],
        variant: :plain,
      }
    end

    it "creates an ImpactHeader with appropriate settings" do
      expect(FlexiblePage::FlexibleSection::ImpactHeader).to receive(:new) do |settings, _|
        expect(settings).to eq(params)
      end

      topical_event
    end

    context "when there's no images" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"]["image"] = nil
        end
      end

      let(:params) do
        {
          description: content_store_response["description"],
          image: nil,
          image_type: :logo,
          title: content_store_response["title"],
          variant: :plain,
        }
      end

      it "creates an ImpactHeader with no image" do
        expect(FlexiblePage::FlexibleSection::ImpactHeader).to receive(:new) do |settings, _|
          expect(settings).to eq(params)
        end

        topical_event
      end
    end

    context "when there are images, but neither header nor logo images" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [
            create_image_hash("interstitial").deep_stringify_keys,
          ]
        end
      end

      let(:params) do
        {
          description: content_store_response["description"],
          image: nil,
          image_type: :logo,
          title: content_store_response["title"],
          variant: :plain,
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
          description: content_store_response["description"],
          image_type: :header,
          title: content_store_response["title"],
          image: create_image_hash("header"),
          variant: :plain,
        }
      end

      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [
            create_image_hash("header").deep_stringify_keys,
            create_image_hash("logo").deep_stringify_keys,
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
          description: content_store_response["description"],
          image_type: :logo,
          title: content_store_response["title"],
          image: create_image_hash("logo"),
          variant: :plain,
        }
      end

      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [
            create_image_hash("logo").deep_stringify_keys,
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
          description: content_store_response["description"],
          image: {
            sources: {
              desktop: content_store_response["details"]["image"]["high_resolution_url"],
              desktop_2x: nil,
              tablet: content_store_response["details"]["image"]["medium_resolution_url"],
              tablet_2x: nil,
              mobile: content_store_response["details"]["image"]["medium_resolution_url"],
              mobile_2x: nil,
            },
          },
          image_type: :logo,
          title: content_store_response["title"],
          variant: :notable_death,
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
    it "creates a ContentThenSidebar with content Govspeak without a sidebar Image (legacy logos always go in the impact header if present)" do
      allow(FlexiblePage::FlexibleSection::ContentThenSidebarLayout).to receive(:new)

      topical_event

      expect(FlexiblePage::FlexibleSection::ContentThenSidebarLayout).to have_received(:new).with(content: instance_of(FlexiblePage::FlexibleSection::Govspeak), sidebar: nil).at_least(:once)
    end

    it "creates the Govspeak from details/body" do
      expect(FlexiblePage::FlexibleSection::Govspeak).to receive(:new).with(govspeak: content_store_response["details"]["body"])

      topical_event
    end

    context "when a logo image (not legacy) is present but no header image" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [create_image_hash("logo").deep_stringify_keys]
        end
      end

      it "creates a ContentThenSidebar with content Govspeak without a sidebar Image (it has put it in the header)" do
        allow(FlexiblePage::FlexibleSection::ContentThenSidebarLayout).to receive(:new)

        topical_event

        expect(FlexiblePage::FlexibleSection::ContentThenSidebarLayout).to have_received(:new).with(content: instance_of(FlexiblePage::FlexibleSection::Govspeak), sidebar: nil).at_least(:once)
      end
    end

    context "when both a logo image (not legacy) and a header image are present" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"].delete("image")
          item["details"]["images"] = [create_image_hash("logo").deep_stringify_keys, create_image_hash("header").deep_stringify_keys]
        end
      end

      it "creates a ContentThenSidebar with content Govspeak with a logo Image" do
        allow(FlexiblePage::FlexibleSection::ContentThenSidebarLayout).to receive(:new)

        topical_event

        expect(FlexiblePage::FlexibleSection::ContentThenSidebarLayout).to have_received(:new).with(content: instance_of(FlexiblePage::FlexibleSection::Govspeak), sidebar: instance_of(FlexiblePage::FlexibleSection::Image)).at_least(:once)
      end

      it "creates the Image from the logo" do
        expect(FlexiblePage::FlexibleSection::Image).to receive(:new).with(image: create_image_hash("logo"))

        topical_event
      end
    end

    context "when a body isn't present" do
      let(:content_store_response) do
        GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018").tap do |item|
          item["details"]["body"] = nil
        end
      end

      it "doesn't create a ContentThenSidebar with content Govspeak" do
        expect(FlexiblePage::FlexibleSection::ContentThenSidebarLayout).not_to receive(:new).with(content: instance_of(FlexiblePage::FlexibleSection::Govspeak))

        topical_event
      end
    end
  end

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
          type: "image_card",
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

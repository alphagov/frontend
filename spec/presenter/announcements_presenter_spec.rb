RSpec.describe AnnouncementsPresenter do
  subject(:presenter) do
    described_class.new(slug, filter_key: "people", search_api: search_api)
  end

  let(:slug) { "rufus-scrimgeour" }
  let(:search_api) { instance_double(GdsApi::Search) }
  let(:results) do
    [
      {
        "title" => "Ministry announces new security measures",
        "link" => "/government/news/new-security-measures",
        "content_store_document_type" => "press_release",
        "public_timestamp" => "2019-11-12T21:07:00.000+00:00",
      },
    ]
  end

  before do
    allow(search_api).to receive(:search).and_return("results" => results)
  end

  describe "#items" do
    it "formats search results for the document list component" do
      expect(presenter.items).to eq([
        {
          link: {
            text: "Ministry announces new security measures",
            path: "/government/news/new-security-measures",
          },
          metadata: {
            public_timestamp: "12 November 2019",
            content_store_document_type: "Press release",
          },
        },
      ])
    end

    it "requests the same announcement fields and filters as Collections" do
      presenter.items

      expect(search_api).to have_received(:search).with(
        count: 10,
        order: "-public_timestamp",
        reject_content_purpose_supergroup: "other",
        fields: %w[title link content_store_document_type public_timestamp],
        filter_people: "rufus-scrimgeour",
      )
    end
  end

  describe "#links" do
    it "builds the people finder and subscription links" do
      expect(presenter.links).to eq(
        email_signup: "/email-signup?link=/government/people/rufus-scrimgeour",
        subscribe_to_feed: "/search/news-and-communications.atom?people=rufus-scrimgeour",
        link_to_news_and_communications: "/search/news-and-communications?people=rufus-scrimgeour",
      )
    end

    context "when the slug includes a locale" do
      let(:slug) { "rufus-scrimgeour.cy" }

      it "uses the locale-less slug in links and filters" do
        expect(presenter.links[:email_signup]).to eq("/email-signup?link=/government/people/rufus-scrimgeour")

        presenter.items
        expect(search_api).to have_received(:search).with(hash_including(filter_people: "rufus-scrimgeour"))
      end
    end
  end
end

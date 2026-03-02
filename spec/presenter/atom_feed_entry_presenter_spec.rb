RSpec.describe AtomFeedEntryPresenter do
  subject(:atom_feed_entry_presenter) { described_class.new(feed_item) }

  let(:feed_item) do
    {
      link: {
        path: "/news/my-item",
        text: "My Topical Event News Item",
      },
      metadata: {
        public_updated_at: Time.zone.parse("2026-06-10 15:30:45"),
        display_type: "News",
        description: "What's Up?",
      },
    }
  end

  describe "#id" do
    it "returns a unique id for the entry" do
      expect(atom_feed_entry_presenter.id).to eq("http://www.dev.gov.uk/news/my-item#2026-06-10T14:30:45Z")
    end
  end

  describe "#url" do
    it "returns a full url from the item's path" do
      expect(atom_feed_entry_presenter.url).to eq("http://www.dev.gov.uk/news/my-item")
    end
  end

  describe "#updated" do
    it "returns the items updated value in UTC zero-offset format" do
      expect(atom_feed_entry_presenter.updated).to eq("2026-06-10T14:30:45Z")
    end
  end

  describe "#title" do
    it "returns the items link text prefixed with the display type" do
      expect(atom_feed_entry_presenter.title).to eq("News: My Topical Event News Item")
    end

    context "when the display type is nil" do
      let(:feed_item) do
        {
          link: {
            path: "/news/my-item",
            text: "My Topical Event News Item",
          },
          metadata: {
            public_updated_at: Time.zone.parse("2026-06-10 15:30:45"),
            description: "What's Up?",
          },
        }
      end

      it "returns the items link text" do
        expect(atom_feed_entry_presenter.title).to eq("My Topical Event News Item")
      end
    end
  end

  describe "#description" do
    it "returns the items metadata description" do
      expect(atom_feed_entry_presenter.description).to eq("What's Up?")
    end
  end

  describe "#display_type" do
    it "returns the items metadata display_type" do
      expect(atom_feed_entry_presenter.display_type).to eq("News")
    end
  end
end

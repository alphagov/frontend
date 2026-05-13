RSpec.describe FlexiblePage::FlexibleSection::Share do
  subject(:share) { described_class.new(heading_text:, links:) }

  let(:heading_text) { "Follow us" }
  let(:links) do
    [
      {
        href: "https://twitter.com/foreignoffice",
        icon: "twitter",
        text: "Twitter",
      },
    ]
  end

  describe "#initialize" do
    it "sets the attributes from the feed hash" do
      expect(share.heading_text).to eq("Follow us")
      expect(share.links).to eq(links)
    end
  end
end

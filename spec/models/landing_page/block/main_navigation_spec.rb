RSpec.describe LandingPage::Block::MainNavigation do
  let(:blocks_hash) do
    {
      "type" => "main_navigation",
      "navigation_group_id" => "Top Menu",
    }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page_with_navigation_groups)) }

  describe "#links" do
    it "returns an array of links from the specified navigation group" do
      expect(subject.links.size).to eq 3
      expect(subject.links.first).to eq({ "text" => "Service Name", "href" => "https://www.gov.uk" })
      expect(subject.links.second).to eq({ "text" => "Test 1", "href" => "/hello" })
      expect(subject.links.third).to eq({
        "text" => "Test 2",
        "href" => "/goodbye",
        "links" => [
          {
            "text" => "Child a",
            "href" => "/a",
          },
          {
            "text" => "Child b",
            "href" => "/b",
          },
        ],
      })
    end
  end

  describe "#full_width?" do
    it "is true" do
      expect(subject.full_width?).to eq(true)
    end
  end
end

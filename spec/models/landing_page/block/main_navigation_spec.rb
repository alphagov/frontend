RSpec.describe LandingPage::Block::MainNavigation do
  let(:subject) { described_class.new(blocks_hash, build(:landing_page_with_navigation_groups)) }
  let(:blocks_hash) do
    {
      "type" => "main_navigation",
      "navigation_group_id" => "Top Menu",
    }
  end

  it_behaves_like "it is a landing-page block"

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

  describe "#name" do
    it "returns the name of the navigation group" do
      expect(subject.name).to eq("Some navigation group name")
    end
  end

  describe "#full_width?" do
    it "is true" do
      expect(subject.full_width?).to eq(true)
    end
  end

  describe "#initialize" do
    context "without the specified navigation group" do
      it "raises an error" do
        expect { described_class.new(blocks_hash, build(:landing_page)) }.to raise_error("Main Navigation block points to a missing navigation group: Top Menu")
      end
    end
  end
end

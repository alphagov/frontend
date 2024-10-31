RSpec.describe LandingPage::Block::SideNavigation do
  let(:blocks_hash) do
    {
      "type" => "side_navigation",
      "navigation_group_id" => "Submenu",
    }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page_with_navigation_groups)) }

  describe "#links" do
    it "returns all of the navigation links from the specified navigation group" do
      expect(subject.links.count).to eq(2)
      expect(subject.links.first["text"]).to eq("Child a")
      expect(subject.links.first["href"]).to eq("/a")
    end
  end
end

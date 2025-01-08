RSpec.describe LandingPage::Block::SideNavigation do
  subject(:side_navigation) { described_class.new(blocks_hash, build(:landing_page_with_navigation_groups)) }

  let(:blocks_hash) do
    {
      "type" => "side_navigation",
      "navigation_group_id" => "Submenu",
    }
  end

  it_behaves_like "it is a landing-page block"

  describe "#links" do
    it "returns all of the navigation links from the specified navigation group" do
      expect(side_navigation.links.count).to eq(2)
      expect(side_navigation.links.first["text"]).to eq("Child a")
      expect(side_navigation.links.first["href"]).to eq("/a")
    end
  end

  describe "#initialize" do
    context "without the specified navigation group" do
      it "raises an error" do
        expect { described_class.new(blocks_hash, build(:landing_page)) }.to raise_error("Side Navigation block points to a missing navigation group: Submenu")
      end
    end
  end
end

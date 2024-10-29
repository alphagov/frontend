RSpec.describe LandingPage::Block::SideNavigation do
  let(:blocks_hash) do
    { "type" => "side_navigation" }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  before do
    LandingPage::Block::SideNavigation.send(:remove_const, "LINKS_FILE_PATH")
    LandingPage::Block::SideNavigation.const_set("LINKS_FILE_PATH", "spec/fixtures/landing_page/links/side_navigation.yaml")
  end

  after do
    LandingPage::Block::SideNavigation.send(:remove_const, "LINKS_FILE_PATH")
    LandingPage::Block::SideNavigation.const_set("LINKS_FILE_PATH", "lib/data/landing_page_content_items/links/side_navigation.yaml")
  end

  describe "#links" do
    it "returns all of the navigation links from the specified navigation group" do
      expect(subject.links.count).to eq(2)
      expect(subject.links.first["text"]).to eq("Landing Page")
      expect(subject.links.first["href"]).to eq("/landing-page")
    end
  end
end

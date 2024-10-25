RSpec.describe LandingPage::Block::SideNavigation do
  let(:block_hash) do
    { "type" => "side_navigation" }
  end

  before do
    LandingPage::Block::SideNavigation.send(:remove_const, "LINKS_FILE_PATH")
    LandingPage::Block::SideNavigation.const_set("LINKS_FILE_PATH", "spec/fixtures/landing_page/links/side_navigation.yaml")
  end

  after do
    LandingPage::Block::SideNavigation.send(:remove_const, "LINKS_FILE_PATH")
    LandingPage::Block::SideNavigation.const_set("LINKS_FILE_PATH", "lib/data/landing_page_content_items/links/side_navigation.yaml")
  end

  describe "#links" do
    it "returns all of the side navigation links" do
      links = described_class.new(block_hash).links
      expect(links.count).to eq(2)
      expect(links.first["text"]).to eq("Landing Page")
      expect(links.first["href"]).to eq("/landing-page")
    end
  end
end

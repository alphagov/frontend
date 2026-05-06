RSpec.describe FlexiblePage::FlexibleSection::Link do
  subject(:link) { described_class.new(link: link_val, link_text:) }

  let(:link_val) { "/cookies" }
  let(:link_text) { "Cookies" }

  describe "#initialize" do
    it "sets the attributes from the parameters" do
      expect(link.link).to eq("/cookies")
      expect(link.link_text).to eq("Cookies")
    end
  end
end

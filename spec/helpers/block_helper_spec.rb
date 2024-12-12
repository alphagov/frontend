RSpec.describe BlockHelper do
  include described_class

  describe "#render_block" do
    it "returns an empty string when a partial template doesn't exist" do
      block = instance_double(LandingPage::Block::Base, type: "not_a_block")
      expect(render_block(block)).to be_empty
    end
  end
end

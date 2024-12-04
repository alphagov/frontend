RSpec.describe BlockHelper do
  include BlockHelper

  describe "#render_block" do
    it "returns an empty string when a partial template doesn't exist" do
      block = double(type: "not_a_block")
      expect(render_block(block)).to be_empty
    end
  end
end

RSpec.describe BlockHelper do
  include BlockHelper

  describe "tab_items_to_component_format" do
    let(:tab_items) do
      [
        {
          "id" => "tab-1",
          "label" => "Item 1",
          "content" => "Here's the content for item one",
        },
      ]
    end

    it "wraps content in a govuk style" do
      expect(tab_items_to_component_format(tab_items).first[:content]).to include("govuk-body")
    end
  end

  describe "#render_block" do
    it "returns an empty string when a partial template doesn't exist" do
      block = double(type: "not_a_block")
      expect(render_block(block)).to be_empty
    end
  end
end

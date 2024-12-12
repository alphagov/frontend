RSpec.describe LandingPage::Block::Component do
  it_behaves_like "it is a landing-page block"

  let(:blocks_hash) do
    { "type" => "component",
      "component_name" => "big_number",
      "number" => 123,
      "label" => "Number of things" }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  describe "allowed list of components" do
    it "allows components on the list" do
      expect { subject }.not_to raise_error
    end

    context "when the component_name is not in the allowed list" do
      let(:blocks_hash) do
        { "type" => "component",
          "component_name" => "layout_for_public",
          "number" => 123,
          "label" => "Number of things" }
      end

      it "raises an error" do
        expect { subject }.to raise_error("Component layout_for_public is not in the allowed list of components for this block")
      end
    end
  end

  describe "#component_attributes" do
    it "returns all attributes except the type and component_name" do
      expect(subject.component_attributes).to eq(number: 123, label: "Number of things")
    end
  end
end

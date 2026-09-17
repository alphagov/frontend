RSpec.describe TopicalEvent do
  subject(:topical_event) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }

  describe "#header_image" do
    it "returns nil" do
      expect(topical_event.header_image).to be_nil
    end
  end

  describe "#logo_image" do
    it "returns nil" do
      expect(topical_event.logo_image).to be_nil
    end
  end

  describe "#legacy_logo" do
    it "returns nil" do
      expect(topical_event.legacy_logo).to be_nil
    end
  end
end

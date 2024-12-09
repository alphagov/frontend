RSpec.describe PlacePresenter do
  describe "#preposition" do
    let(:content_store_response) { GovukSchemas::Example.find("place", example_name: "find-regional-passport-office") }

    it "returns near if there are no places" do
      content_item = Place.new(content_store_response, [])
      expect(described_class.new(content_item).preposition).to eq("near")
    end

    it "returns near if places are addresses" do
      places = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo" }]
      content_item = Place.new(content_store_response, places)

      expect(described_class.new(content_item).preposition).to eq("near")
    end

    it "returns far if places are counties" do
      places = [{ "gss" => "123" }]
      content_item = Place.new(content_store_response, places)

      expect(described_class.new(content_item).preposition).to eq("for")
    end
  end
end

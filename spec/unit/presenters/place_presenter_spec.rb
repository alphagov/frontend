RSpec.describe PlacePresenter do
  let(:content_store_response) do
    GovukSchemas::Example.find("place", example_name: "find-regional-passport-office")
  end

  let(:content_item) { Place.new(content_store_response) }

  describe "#places" do
    it "shows the places" do
      places = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo" }]
      expected = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo", "text" => "http://www.example.com/foo_foo_foorentinafoo", "address" => "44, Foo Foo Forest" }]

      expect(described_class.new(content_item, places).places).to eq(expected)
    end
  end

  describe "#preposition" do
    it "returns near if there are no places" do
      expect(described_class.new(content_item, []).preposition).to eq("near")
    end

    it "returns near if places are addresses" do
      places = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo" }]
      expect(described_class.new(content_item, places).preposition).to eq("near")
    end

    it "returns far if places are counties" do
      places = [{ "gss" => "123" }]
      expect(described_class.new(content_item, places).preposition).to eq("for")
    end
  end
end

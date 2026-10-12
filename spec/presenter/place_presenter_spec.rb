RSpec.describe PlacePresenter do
  subject(:place_presenter) { described_class.new(content_item, places) }

  let(:content_item) { Place.new(content_store_response) }
  let(:content_store_response) do
    GovukSchemas::Example.find("place", example_name: "find-regional-passport-office")
  end
  let(:places) do
    [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo" }]
  end

  describe "#places" do
    it "shows the places" do
      expected = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo", "text" => "http://www.example.com/foo_foo_foorentinafoo", "address" => "44, Foo Foo Forest" }]

      expect(place_presenter.places).to eq(expected)
    end
  end

  describe "#preposition" do
    context "when places are addresses" do
      it "returns near" do
        expect(place_presenter.preposition).to eq("near")
      end
    end

    context "when there are no places" do
      let(:places) { [] }

      it "returns near" do
        expect(place_presenter.preposition).to eq("near")
      end
    end

    context "when places are counties" do
      let(:places) { [{ "gss" => "123" }] }

      it "returns far if places are counties" do
        expect(place_presenter.preposition).to eq("for")
      end
    end
  end
end

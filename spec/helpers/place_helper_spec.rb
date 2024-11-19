RSpec.describe PlaceHelper do
  include described_class

  describe "#preposition_for_place_list" do
    it "returns near if there are no places" do
      expect(preposition_for_place_list({})).to eq("near")
    end

    it "returns near if places are addresses" do
      places = [{ "address1" => "44", "address2" => "Foo Foo Forest", "url" => "http://www.example.com/foo_foo_foorentinafoo" }]

      expect(preposition_for_place_list(places)).to eq("near")
    end

    it "returns far if places are counties" do
      places = [{ "gss" => "123" }]

      expect(preposition_for_place_list(places)).to eq("for")
    end
  end
end

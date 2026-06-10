RSpec.describe PostcodeLookup do
  include GdsApi::TestHelpers::LocationsApi

  subject(:postcode_lookup) { described_class.new(postcode) }

  let(:postcode) { "SL3 6NB" }

  before do
    stub_locations_api_has_location(
      postcode,
      [
        { "latitude" => 51.0, "longitude" => -0.1, "address" => "1 local street", "local_custodian_code" => 440 },
        { "latitude" => 51.0, "longitude" => -0.1, "address" => "lamp-post", "local_custodian_code" => 7655 },
      ],
    )
  end

  describe "#addresses" do
    it "returns a map of discovered addresses with custodian codes in openstructs, except the ordnance survey one" do
      addresses = postcode_lookup.addresses

      expect(addresses.count).to eq(1)
      expect(addresses.first.address).to eq("1 local street")
      expect(addresses.first.local_custodian_code).to eq(440)
    end
  end

  describe "#local_custodian_codes" do
    it "returns discovered local_custodian codes, except the ordnance survey one" do
      expect(postcode_lookup.local_custodian_codes).to eq([440])
    end
  end
end

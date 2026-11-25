RSpec.describe PostcodeLookup do
  subject(:postcode_lookup) { described_class.new("EX4 MPL3") }

  let(:api_response) do
    {
      "results" => [
        { "latitude" => 51.0, "longitude" => -0.1, "address" => "1 local street", "local_custodian_code" => 440 },
        { "latitude" => 51.0, "longitude" => -0.1, "address" => "lamp-post", "local_custodian_code" => 7655 },
      ],
    }
  end
  let(:locations_api) { instance_double(GdsApi::LocationsApi, results_for_postcode: api_response) }

  before { allow(Frontend).to receive(:locations_api).and_return(locations_api) }

  describe "<initialization>" do
    context "when the postcode is blank" do
      subject(:postcode_lookup) { described_class.new("") }

      it "raises a PostcodeInvalid error" do
        expect { postcode_lookup }.to raise_error(PostcodeLookup::PostcodeInvalid)
      end
    end

    context "when the api returns a crown dependency flag" do
      let(:api_response) do
        {
          "errors" => { "postcode" => ["No results found for given postcode"] },
          "postcode_category" => "CROWN_DEPENDENCY",
        }
      end

      it "raises a PostcodeCrownDependency error" do
        expect { postcode_lookup }.to raise_error(PostcodeLookup::PostcodeCrownDependency)
      end
    end

    context "when the api returns empty results" do
      let(:api_response) do
        {
          "results" => [],
          "postcode_category" => "RECOGNISED",
        }
      end

      it "raises a PostcodeNoResults error" do
        expect { postcode_lookup }.to raise_error(PostcodeLookup::PostcodeNoResults)
      end
    end

    context "when the api returns a 404" do
      before { allow(locations_api).to receive(:results_for_postcode).with(any_args).and_raise(GdsApi::HTTPNotFound.new("")) }

      it "raises a PostcodeNotFound error" do
        expect { postcode_lookup }.to raise_error(PostcodeLookup::PostcodeNotFound)
      end
    end

    context "when the api returns a 400" do
      before { allow(locations_api).to receive(:results_for_postcode).with(any_args).and_raise(GdsApi::HTTPClientError.new("")) }

      it "raises a PostcodeInvalid error" do
        expect { postcode_lookup }.to raise_error(PostcodeLookup::PostcodeInvalid)
      end
    end
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

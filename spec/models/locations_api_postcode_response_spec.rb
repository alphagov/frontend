RSpec.describe LocationsApiPostcodeResponse do
  subject(:locations_api_postcode_response) { described_class.new(postcode, local_custodian_codes, error) }

  let(:postcode) { "LS15AT" }
  let(:local_custodian_codes) { [4270] }
  let(:error) { nil }

  describe "#single_authority?" do
    it "returns true" do
      expect(locations_api_postcode_response.single_authority?).to be true
    end

    context "when more than one authority is passed in" do
      let(:local_custodian_codes) { [4270, 4721] }

      it "returns false" do
        expect(locations_api_postcode_response.single_authority?).to be false
      end

      context "when two are passed in but one of them is the OS LCC" do
        let(:local_custodian_codes) { [4270, 7655] }

        it "ignores 7655 and returns true" do
          expect(locations_api_postcode_response.single_authority?).to be true
        end
      end
    end
  end
end

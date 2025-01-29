RSpec.describe ElectoralService do
  include ElectionHelpers

  subject(:electoral_service) { described_class.new(postcode:, uprn:) }

  let(:postcode) { "NW14DU" }
  let(:uprn) { nil }
  let(:status) { 200 }

  before do
    if postcode.nil?
      stub_api_address_lookup(uprn, status:)
    else
      stub_api_postcode_lookup(postcode, status:)
    end
  end

  describe "#make_request" do
    context "when election service not available" do
      let(:status) { 500 }

      it "returns empty body" do
        with_electoral_api_url do
          electoral_service.make_request
        end
        expect(electoral_service.body).to eq({})
      end

      it "returns correct error string" do
        with_electoral_api_url do
          electoral_service.make_request
        end
        expect(electoral_service.error).to eq("electoralServiceNotAvailable")
      end
    end
  end

  describe "#ok?" do
    context "when election service not available" do
      let(:status) { 500 }

      it "returns false" do
        with_electoral_api_url do
          electoral_service.make_request
        end
        expect(electoral_service.ok?).to be(false)
      end
    end
  end

  describe "#error?" do
    context "when election service not available" do
      let(:status) { 500 }

      it "returns true" do
        with_electoral_api_url do
          electoral_service.make_request
        end
        expect(electoral_service.error?).to be(true)
      end
    end
  end
end

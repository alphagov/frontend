RSpec.describe DetailedGuide do
  subject(:detailed_guide) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide") }

  it_behaves_like "it can have national applicability", "detailed_guide", "national_applicability_detailed_guide"
  it_behaves_like "it can have single page notifications", "detailed_guide", "detailed_guide"
  it_behaves_like "it has historical government information", "detailed_guide", "political_detailed_guide"
  it_behaves_like "it has updates", "detailed_guide", "detailed_guide"
  it_behaves_like "it has no updates", "detailed_guide", "national_applicability_detailed_guide"
  it_behaves_like "it can be withdrawn", "detailed_guide", "withdrawn_detailed_guide"

  describe "#headers" do
    context "when there are headers in the details hash" do
      it "returns a list of headings" do
        expect(detailed_guide.headers).to eq(content_store_response["details"]["headers"])
      end
    end

    context "when there are no headers in the details hash" do
      let(:content_store_response) do
        GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide").tap do |item|
          item["details"].delete("headers")
        end
      end

      it "returns an empty array" do
        expect(detailed_guide.headers).to eq([])
      end
    end
  end

  describe "#contributors" do
    context "when emphasised organisation is present" do
      let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "england-2014-to-2020-european-structural-and-investment-funds") }

      it "returns the emphasised organisation first" do
        expect(detailed_guide.contributors.count).to eq(4)
        expect(detailed_guide.contributors.collect(&:content_id)).to eq(content_store_response["details"]["emphasised_organisations"])
      end
    end
  end
end

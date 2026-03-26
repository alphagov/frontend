RSpec.describe DetailedGuide do
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
        content_item = described_class.new(content_store_response)
        details_headers = content_store_response["details"]["headers"]

        expect(content_item.headers).to eq(details_headers)
      end
    end

    context "when there are no headers in the details hash" do
      it "returns an empty array" do
        content_store_response["details"].delete("headers")
        content_item = described_class.new(content_store_response)

        expect(content_item.headers).to eq([])
      end
    end
  end

  describe "#contributors" do
    context "when emphasised organisation is present" do
      it "returns the emphasised organisation first" do
        content_store_response = GovukSchemas::Example.find("detailed_guide", example_name: "england-2014-to-2020-european-structural-and-investment-funds")
        content_item = described_class.new(content_store_response)

        organisations = content_store_response["links"]["organisations"]
        expect(content_item.contributors.count).to eq(4)
        expect(content_item.contributors.collect(&:content_id)).to eq(content_item["details"]["emphasised_organisations"])
      end
    end
  end
end

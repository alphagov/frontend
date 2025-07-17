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
        expect(content_item.contributors[0].title).to eq(organisations[0]["title"])
        expect(content_item.contributors[1].title).to eq(organisations[1]["title"])
        expect(content_item.contributors[2].title).to eq(organisations[2]["title"])
        expect(content_item.contributors[3].title).to eq(organisations[3]["title"])
      end
    end
  end

  describe "#logo" do
    context "when image is present for a detailed guide page" do
      it "returns the URL and alt text for the image" do
        content_store_response = GovukSchemas::Example.find("detailed_guide", example_name: "england-2014-to-2020-european-structural-and-investment-funds")
        content_item = described_class.new(content_store_response)
        image_url = content_store_response.dig("details", "image", "url")
        expect(content_item.logo).to eq({
          path: image_url,
          alt_text: "European structural investment funds",
        })
      end
    end

    context "when image is not present for a detailed guide page" do
      it "returns nil" do
        content_store_response = GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide")
        content_item = described_class.new(content_store_response)

        expect(content_item.logo).to be_nil
      end
    end
  end
end

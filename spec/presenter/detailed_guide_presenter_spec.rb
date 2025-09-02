RSpec.describe DetailedGuidePresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide") }
  let(:content_item) { DetailedGuide.new(content_store_response) }

  it_behaves_like "it can have a contents list", "detailed_guide", "detailed_guide"

  describe "#logo" do
    context "when image is not present" do
      it "returns nil" do
        expect(presenter.logo).to be_nil
      end
    end

    context "when image is present" do
      let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "england-2014-to-2020-european-structural-and-investment-funds") }

      it "returns the URL and alt text for the image" do
        image_url = content_store_response.dig("details", "image", "url")

        expect(presenter.logo).to eq({
          path: image_url,
          alt_text: "European structural investment funds",
        })
      end
    end
  end
end

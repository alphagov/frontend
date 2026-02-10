RSpec.describe HmrcManualSectionPresenter do
  include ContentStoreHelpers

  subject(:hmrc_manual_section_presenter) { described_class.new(content_item) }

  let(:content_item) { HmrcManualSection.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual_section", example_name: "vatgpb2000") }

  before do
    manual_content_item = GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies")
    stub_content_store_has_item(manual_content_item.fetch("base_path"), manual_content_item)
  end

  it_behaves_like "it can have manual metadata", HmrcManual

  describe "#breadcrumbs" do
    it "returns a link to the manual" do
      expect(hmrc_manual_section_presenter.breadcrumbs).to eq([
        {
          title: "Back to contents",
          url: "/hmrc-internal-manuals/vat-government-and-public-bodies",
        },
      ])
    end

    context "when breadcrumbs are present in the details block" do
      let(:content_store_response) do
        GovukSchemas::Example.find("hmrc_manual_section", example_name: "vatgpb2000").tap do |item|
          item["details"]["breadcrumbs"] = [
            {
              "base_path" => "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgbp2000",
              "section_id" => "VAT GBP 2000",
            },
          ]
        end
      end

      it "appends the specified links to the breadcrumb" do
        expect(hmrc_manual_section_presenter.breadcrumbs).to eq([
          {
            title: "Back to contents",
            url: "/hmrc-internal-manuals/vat-government-and-public-bodies",
          },
          {
            title: "VAT GBP 2000",
            url: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgbp2000",
          },
        ])
      end
    end
  end
end

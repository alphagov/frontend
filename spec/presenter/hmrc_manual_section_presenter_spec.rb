RSpec.describe HmrcManualSectionPresenter do
  include ContentStoreHelpers

  subject(:hmrc_manual_section_presenter) { described_class.new(content_item) }

  let(:content_item) { HmrcManualSection.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual_section", example_name: "vatgpb2000") }
  let(:manual_content_store_response) { GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies") }

  before do
    stub_content_store_has_item(manual_content_store_response.fetch("base_path"), manual_content_store_response)
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

  describe "#document_heading" do
    it "returns the section ID and document title" do
      expect(hmrc_manual_section_presenter.document_heading).to eq("#{content_store_response['details']['section_id']} - #{content_store_response['title']}")
    end

    context "without a section ID" do
      let(:content_store_response) do
        GovukSchemas::Example.find("hmrc_manual_section", example_name: "vatgpb2000").tap do |item|
          item["details"]["section_id"] = nil
        end
      end

      it "returns the document title" do
        expect(hmrc_manual_section_presenter.document_heading).to eq(content_store_response["title"])
      end
    end
  end

  describe "#previous_and_next_links" do
    it "returns the links in a form suitable for the component" do
      expect(hmrc_manual_section_presenter.previous_and_next_links[:next_page]).to eq({
        href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb3000",
        title: "Next page",
      })

      expect(hmrc_manual_section_presenter.previous_and_next_links[:previous_page]).to eq({
        href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
        title: "Previous page",
      })
    end

    context "when the content_item has no siblings" do
      let(:manual_content_store_response) do
        GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies").tap do |item|
          item["details"]["child_section_groups"] = [
            {
              "child_sections": [
                {
                  "section_id": "VATGPB2000",
                  "title": "Bodies governed by public law: contents",
                  "description": "",
                  "base_path": "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb2000",
                },
              ],
            },
          ]
        end
      end

      it "returns an empty hash" do
        expect(hmrc_manual_section_presenter.previous_and_next_links).to eq({})
      end
    end
  end
end

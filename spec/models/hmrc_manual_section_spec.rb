RSpec.describe HmrcManualSection do
  include ContentStoreHelpers

  subject(:hmrc_manual_section) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual_section", example_name: "vatgpb2000") }

  before do
    manual_content_item = GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies")
    stub_content_store_has_item(manual_content_item.fetch("base_path"), manual_content_item)
  end

  it_behaves_like "it can have section groups", "hmrc_manual_section", "vatgpb2000"

  describe "attributes" do
    it "has a section_id set from the content item" do
      expect(hmrc_manual_section.section_id).to eq("VATGPB2000")
    end

    it "has child_section_groups set from the content item" do
      expect(hmrc_manual_section.child_section_groups).to eq(content_store_response["details"]["child_section_groups"])
    end
  end

  end
end

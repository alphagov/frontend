RSpec.describe HmrcManualSection do
  include ContentStoreHelpers

  subject(:hmrc_manual_section) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual_section", example_name: "vatgpb2000") }

  before do
    manual_content_item = GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies")
    stub_content_store_has_item(manual_content_item.fetch("base_path"), manual_content_item)
  end

  it_behaves_like "it can have section groups", "hmrc_manual_section", "vatgpb2000"
end

RSpec.describe HmrcManualPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual", example_name: "hmrc_manual") }
  let(:content_item) { HmrcManual.new(content_store_response) }

  it_behaves_like "it can have manual metadata", "hmrc_manual", "hmrc_manual"
end

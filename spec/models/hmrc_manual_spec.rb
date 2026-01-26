RSpec.describe HmrcManual do
  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies") }

  it_behaves_like "it can have section groups", "hmrc_manual", "vat-government-public-bodies"
  it_behaves_like "it can be a manual", "hmrc_manual", "vat-government-public-bodies"
  it_behaves_like "it can be a manual section", "hmrc_manual", "vat-government-public-bodies"
end

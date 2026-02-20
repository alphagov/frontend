RSpec.describe HmrcManual do
  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual", example_name: "vat-government-public-bodies") }

  it_behaves_like "it can have section groups", "hmrc_manual", "vat-government-public-bodies"
  it_behaves_like "it can have manual updates", "hmrc_manual", "vat-government-public-bodies"
end

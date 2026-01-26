RSpec.describe HmrcManual do
  let(:content_store_response) { GovukSchemas::Example.find("hmrc_manual", example_name: "hmrc_manual") }

  it_behaves_like "it can have section groups", "hmrc_manual", "hmrc_manual"
  it_behaves_like "it can be a manual", "hmrc_manual", "hmrc_manual"
  it_behaves_like "it can be a manual section", "hmrc_manual", "hmrc_manual"
  it_behaves_like "it has updates", "hmrc_manual", "hmrc_manual_with_history"
  it_behaves_like "it has no updates", "hmrc_manual", "hmrc_manual"
end
